using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Sockets;
using System.Threading;
using System.Threading.Tasks;

namespace TssAcs
{
    public static class Constants
    {
        public const int MEM_PAGE_SIZE = 256;
        public const int MEM_TYPE_RAM = 1;
        public const int MEM_TYPE_EEPROM = 3;
        public const int MEM_OP_OFF = 1;
        public const int MEM_OP_RD = 2;
        public const int MEM_OP_WR = 3;
        public const int KEY_SIZE = 8;
    }

    public static class Utils
    {
        public static byte FromBcd(byte b)
        {
            return (byte)(((b >> 4) * 10) + (b & 0x0F));
        }

        public static byte ToBcd(byte b)
        {
            byte x = (byte)(b / 10);
            return (byte)((x << 4) + (b - (x * 10)));
        }

        public static byte SecsToRelayDuration(double secs)
        {
            int v = (int)(secs * 1000);
            return (byte)((v * 4) / 1000);
        }

        public static int DataToInt(byte[] data)
        {
            int r = 0;
            for (int i = 0; i < data.Length; i++)
            {
                r |= data[i] << (8 * i);
            }
            return r;
        }

        public static byte[] IntToData(int val, int n)
        {
            byte[] result = new byte[n];
            for (int i = 0; i < n; i++)
            {
                result[i] = (byte)((val >> (i * 8)) & 0xFF);
            }
            return result;
        }

        public static byte CheckSum(byte[] data)
        {
            byte r = 0;
            foreach (byte b in data)
            {
                r = (byte)((r + b) & 0xFF);
            }
            return r;
        }
    }

    public class DateTime
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public int Day { get; set; }
        public int Hour { get; set; }
        public int Minute { get; set; }
        public int Second { get; set; }

        public override string ToString()
        {
            return $"{GetType().Name}(Year: {Year}, Month: {Month}, Day: {Day}, Hour: {Hour}, Minute: {Minute}, Second: {Second})";
        }
    }

    public class Event
    {
        public byte Addr { get; set; }
        public int No { get; set; }
        public bool IsLast { get; set; }
        public bool IsComplex { get; set; }
        public DateTime Dt { get; set; }

        public override string ToString()
        {
            return $"{GetType().Name}(Addr: {Addr}, No: {No}, IsLast: {IsLast}, IsComplex: {IsComplex}, Dt: {Dt})";
        }
    }

    public class EventPort : Event
    {
        public int Port { get; set; }
    }

    public class EventDoor : EventPort
    {
        public bool IsOpen { get; set; }
    }

    public class EventButton : EventPort
    {
        public bool IsOpen { get; set; }
    }

    public class EventKey : EventPort
    {
        public bool IsOpen { get; set; }
        public int Code { get; set; }
        public bool IsKeySearchDone { get; set; }
        public bool IsKeyFound { get; set; }
        public bool IsAccessGranted { get; set; }
        public bool IsTimeRestrictDone { get; set; }
        public bool IsTimeRestrict { get; set; }
    }

    public class Key
    {
        public int Code { get; set; }
        public List<int> Mask { get; set; } = new List<int>();
        public int PersCat { get; set; }
        public bool SuppressDoorEvent { get; set; }
        public bool OpenAlways { get; set; }
        public bool IsSilent { get; set; }

        public override string ToString()
        {
            return $"{GetType().Name}(Code: {Code}, Mask: [{string.Join(", ", Mask)}], PersCat: {PersCat}, " +
                   $"SuppressDoorEvent: {SuppressDoorEvent}, OpenAlways: {OpenAlways}, IsSilent: {IsSilent})";
        }
    }

    public class ErrorAcs : Exception
    {
        public ErrorAcs(string message) : base(message) { }
    }

    public class ErrorNoResponse : ErrorAcs
    {
        public ErrorNoResponse(double responseTimeout) 
            : base($"no response in {responseTimeout}") { }
    }

    public class ErrorResponse : ErrorAcs
    {
        public ErrorResponse(string message) : base(message) { }
    }

    public abstract class Channel : IDisposable
    {
        protected readonly SemaphoreSlim _lock = new SemaphoreSlim(1, 1);
        protected readonly double _responseTimeout;

        protected Channel(double responseTimeout)
        {
            _responseTimeout = responseTimeout;
        }

        public abstract void FlushInput();

        protected abstract Task<byte[]> ReadSomeAsync(int size);
        protected abstract Task WriteAsync(byte[] data);

        protected async Task<byte[]> ReadAsync(int size)
        {
            if (size <= 0)
                throw new ArgumentException("Size must be greater than 0", nameof(size));

            var result = new List<byte>();
            while (true)
            {
                var chunk = await ReadSomeAsync(size - result.Count);
                result.AddRange(chunk);
                if (result.Count >= size)
                    break;
            }
            return result.ToArray();
        }

        protected async Task<byte[]> ReadUntilAsync(int size, params byte[] anyOf)
        {
            if (size <= 0)
                throw new ArgumentException("Size must be greater than 0", nameof(size));

            var result = new List<byte>();
            while (true)
            {
                var chunk = await ReadSomeAsync(size - result.Count);
                result.AddRange(chunk);

                bool found = false;
                for (int i = 0; i < result.Count; i++)
                {
                    if (Array.IndexOf(anyOf, result[i]) != -1)
                    {
                        result.RemoveRange(0, i);
                        found = true;
                        break;
                    }
                }

                if (result.Count >= size)
                {
                    if (!found)
                        throw new ErrorResponse("unexpected response");
                    break;
                }
            }
            return result.ToArray();
        }

        protected void EnsureCheckSumMatch(byte[] data)
        {
            var cs = Utils.CheckSum(data[..^1]);
            if (cs != data[^1])
                throw new ErrorResponse("check sum not match");
        }

        public virtual void Dispose()
        {
            _lock.Dispose();
        }
    }

    public class ChannelRS232 : Channel
    {
        private readonly System.IO.Ports.SerialPort _port;

        public ChannelRS232(string portName, int baudRate = 19200, double responseTimeout = 0.04)
            : base(responseTimeout)
        {
            _port = new System.IO.Ports.SerialPort(portName, baudRate)
            {
                ReadTimeout = (int)(responseTimeout * 1000),
                WriteTimeout = (int)(responseTimeout * 1000)
            };
            _port.Open();
        }

        public override void FlushInput()
        {
            _port.DiscardInBuffer();
        }

        protected override async Task<byte[]> ReadSomeAsync(int size)
        {
            if (size <= 0)
                throw new ArgumentException("Size must be greater than 0", nameof(size));

            var buffer = new byte[size];
            int bytesRead = await _port.BaseStream.ReadAsync(buffer, 0, size);
            
            if (bytesRead == 0)
                throw new ErrorNoResponse(_responseTimeout);

            return buffer[..bytesRead];
        }

        protected override async Task WriteAsync(byte[] data)
        {
            await _port.BaseStream.WriteAsync(data, 0, data.Length);
        }

        public override void Dispose()
        {
            _port?.Dispose();
            base.Dispose();
        }
    }

    public class ChannelTCP : Channel
    {
        private readonly TcpClient _client;
        private readonly NetworkStream _stream;

        public ChannelTCP(string host, int port = 5086, double responseTimeout = 0.5)
            : base(responseTimeout)
        {
            _client = new TcpClient();
            _client.Connect(host, port);
            _stream = _client.GetStream();
            _stream.ReadTimeout = (int)(responseTimeout * 1000);
            _stream.WriteTimeout = (int)(responseTimeout * 1000);
        }

        public override void FlushInput()
        {
            try
            {
                var buffer = new byte[256];
                _stream.Read(buffer, 0, buffer.Length);
            }
            catch (IOException) { }
        }

        protected override async Task<byte[]> ReadSomeAsync(int size)
        {
            if (size <= 0)
                throw new ArgumentException("Size must be greater than 0", nameof(size));

            try
            {
                var buffer = new byte[size];
                int bytesRead = await _stream.ReadAsync(buffer, 0, size);
                
                if (bytesRead == 0)
                {
                    _client.Close();
                    throw new IOException("disconnected");
                }

                return buffer[..bytesRead];
            }
            catch (IOException ex)
            {
                Console.WriteLine($"ChannelTCP.ReadSomeAsync -> Exception ({ex.GetType()}): {ex.Message}; ResponseTimeout: {_responseTimeout}");
                throw new ErrorNoResponse(_responseTimeout);
            }
        }

        protected override async Task WriteAsync(byte[] data)
        {
            await _stream.WriteAsync(data, 0, data.Length);
        }

        public override void Dispose()
        {
            _stream?.Dispose();
            _client?.Dispose();
            base.Dispose();
        }
    }

    // Note: ChannelRS422 implementation would require platform-specific code
    // and is omitted here as it depends on external hardware/drivers

    public class TssAcs : IDisposable
    {
        private readonly Channel _channel;

        public TssAcs(Channel channel)
        {
            _channel = channel;
        }

        public async Task<byte> ProgIdAsync(byte addr)
        {
            var q = new byte[] { 0x16, 0x20, addr };
            await _channel._lock.WaitAsync();
            try
            {
                await _channel.WriteAsync(q);
                var r = await _channel.ReadSomeAsync(1);
                return r[0];
            }
            finally
            {
                _channel._lock.Release();
            }
        }

        public async Task<List<byte>> FindAddrsAsync()
        {
            var result = new List<byte>();
            var q = new byte[] { 0x16, 0x20, 0 };
            
            for (byte addr = 0; addr < 255; addr++)
            {
                q[2] = addr;
                await _channel._lock.WaitAsync();
                try
                {
                    await _channel.WriteAsync(q);
                    try
                    {
                        await _channel.ReadSomeAsync(1);
                        result.Add(addr);
                    }
                    catch (ErrorNoResponse) { }
                }
                finally
                {
                    _channel._lock.Release();
                }
            }
            return result;
        }

        public async Task<(byte, byte)> ProgVerAsync(byte addr)
        {
            var r = await Cmd4cAsync(addr, 0x10);
            return (r[1], r[0]);
        }

        public async Task<int> SerNumAsync(byte addr)
        {
            var r = await Cmd4cAsync(addr, 0x20);
            return Utils.DataToInt(r[..4]);
        }

        public async Task RestartProgAsync(byte addr)
        {
            var q = new byte[] { 0x16, 0x23, addr };
            await _channel._lock.WaitAsync();
            try
            {
                await _channel.WriteAsync(q);
            }
            finally
            {
                _channel._lock.Release();
            }
        }

        public async Task SetDateTimeAsync(byte addr, DateTime dt)
        {
            await _channel._lock.WaitAsync();
            try
            {
                await _channel.WriteAsync(MakeCmd88Or89(addr, 0xA9, dt.Day, dt.Month, dt.Year));
                await _channel.WriteAsync(MakeCmd88Or89(addr, 0xA8, dt.Second, dt.Minute, dt.Hour));
            }
            finally
            {
                _channel._lock.Release();
            }
        }

        public async Task<DateTime> GetDateTimeAsync(byte addr)
        {
            var r = await Cmd4eAsync(addr);
            var dt = new DateTime
            {
                Year = Utils.FromBcd(r[5]),
                Month = Utils.FromBcd(r[4]),
                Day = Utils.FromBcd(r[3]),
                Hour = Utils.FromBcd(r[2]),
                Minute = Utils.FromBcd(r[1]),
                Second = Utils.FromBcd(r[0])
            };
            return dt;
        }

        public async Task<(int, int)> EventsInfoAsync(byte addr)
        {
            return await EventsOrKeysInfoAsync(addr, 1);
        }

        public async Task<(int, int)> KeysInfoAsync(byte addr)
        {
            return await EventsOrKeysInfoAsync(addr, 8);
        }

        public async Task DelAllEventsAsync(byte addr)
        {
            await DelAllKeysOrEventsAsync(addr, 0x80);
        }

        public async Task<Event> GetEventAsync(byte addr, bool isComplex)
        {
            var q = new byte[] { 0x16, (byte)(isComplex ? 0x2B : 0x3B), addr };
            await _channel._lock.WaitAsync();
            try
            {
                await _channel.WriteAsync(q);
                var r = await _channel.ReadUntilAsync(3, addr);
                if (r[1] == 0 && r[2] == addr)
                    return null;
                if (r[1] == 0 && r[2] == (byte)(~addr & 0xFF))
                    throw new ErrorResponse("busy");

                int n = 17 - r.Length;
                if (n > 0)
                    r = r.Concat(await _channel.ReadAsync(n)).ToArray();
            }
            finally
            {
                _channel._lock.Release();
            }

            r = r[..17];
            _channel.EnsureCheckSumMatch(r);
            return MakeEvent(r);
        }

        public async Task<Key> FindKeyAsync(byte addr, int code)
        {
            var q = Utils.IntToData(code, 6);
            var r = await CmdC4Async(addr, 2, q);
            if (r.Length == Constants.KEY_SIZE)
            {
                return ToKey(r);
            }
            return null;
        }

        public async Task AddKeyAsync(byte addr, Key key)
        {
            var q = FromKey(key);
            await CmdC4Async(addr, 1, q);
        }

        public async Task DelKeyAsync(byte addr, int code)
        {
            var r = await CmdC4Async(addr, 0, Utils.IntToData(code, 6));
            if (r[0] == 0x80)
                throw new ErrorResponse("failed");
        }

        public async Task DelAllKeysAsync(byte addr)
        {
            await DelAllKeysOrEventsAsync(addr, 0x81);
        }

        private static byte[] MakeCmd88Or89(byte addr, byte op, byte v1, byte v2, byte v3)
        {
            return new byte[] { 0x16, op, addr, Utils.ToBcd(v1), Utils.ToBcd(v2), Utils.ToBcd(v3) };
        }

        private static Event MakeEvent(byte[] data)
        {
            byte b = (byte)(data[1] & 0x0F);
            if (b == 0b0011)
                return new EventDoor(data, true);
            else if (b == 0b1011)
                return new EventDoor(data, false);
            else if ((b & 0b111) == 0b100)
                return new EventButton(data, false);
            else if ((b & 0b111) == 0b101)
                return new EventButton(data, true);
            else if ((b & 0b111) == 0b110)
                return new EventKey(data, false);
            else if ((b & 0b111) == 0b111)
                return new EventKey(data, true);
            return null;
        }

        private static Key ToKey(byte[] data)
        {
            var key = new Key
            {
                Code = Utils.DataToInt(data[..6])
            };

            byte b = data[6];
            for (int i = 0; i < Constants.KEY_SIZE; i++)
            {
                key.Mask.Add((b & (1 << i)) != 0 ? i + 1 : 0);
            }

            b = data[7];
            key.PersCat = (b & 0x0F) + 1;
            key.SuppressDoorEvent = (b & (1 << 5)) != 0;
            key.OpenAlways = (b & (1 << 6)) != 0;
            key.IsSilent = (b & (1 << 7)) != 0;

            return key;
        }

        private static byte[] FromKey(Key key)
        {
            var data = Utils.IntToData(key.Code, 6);
            byte mask = 0;
            foreach (var b in key.Mask)
            {
                if (b != 0)
                    mask |= (byte)(1 << (b - 1));
            }
            if (mask == 0)
                throw new ArgumentException("Invalid key mask");

            data.Add(mask);

            byte flags = (byte)(key.PersCat - 1);
            if (key.SuppressDoorEvent)
                flags |= 1 << 5;
            if (key.OpenAlways)
                flags |= 1 << 6;
            if (key.IsSilent)
                flags |= 1 << 7;

            data.Add(flags);
            return data.ToArray();
        }

        private async Task DelAllKeysOrEventsAsync(byte addr, byte op)
        {
            var serNum = await SerNumAsync(addr);
            var data = new List<byte> { op, addr };
            data.AddRange(Utils.IntToData(serNum, 4));
            var r = await CmdC4Async(addr, op, data.ToArray());
            if (r[0] != 0)
                throw new ErrorResponse("failed");
        }

        private async Task<(int, int)> EventsOrKeysInfoAsync(byte addr, byte op)
        {
            var r = await Cmd4cAsync(addr, op);
            int dim = r[0];
            int capacity = Utils.DataToInt(r[1..(dim + 1)]);
            int count = Utils.DataToInt(r[(1 + dim)..(1 + dim + dim)]);
            return (capacity, count);
        }

        private async Task<byte[]> Cmd4cAsync(byte addr, byte op)
        {
            var q = new byte[] { 0x16, 0x6C, addr, op };
            await _channel._lock.WaitAsync();
            try
            {
                await _channel.WriteAsync(q);
                var r = await _channel.ReadUntilAsync(3, addr);
                if (r[1] == 0 && r[2] == (byte)(~addr & 0xFF))
                    throw new ErrorResponse("busy");

                int packLen = r[1] - 1;
                int n = 2 + packLen + 1 - r.Length;
                if (n > 0)
                    r = r.Concat(await _channel.ReadAsync(n)).ToArray();
            }
            finally
            {
                _channel._lock.Release();
            }

            r = r[..(2 + packLen + 1)];
            _channel.EnsureCheckSumMatch(r);
            if (packLen == 1 && r[2] == 0xFF)
                throw new ErrorResponse("unsupported operation");

            return r[2..(2 + packLen)];
        }

        private async Task<byte[]> Cmd4eAsync(byte addr)
        {
            var q = new byte[] { 0x16, 0x6E, addr, 0b1110111 };
            await _channel._lock.WaitAsync();
            try
            {
                await _channel.WriteAsync(q);
                var r = await _channel.ReadUntilAsync(3, addr);
                if (r[1] == 0 && r[2] == (byte)(~addr & 0xFF))
                    throw new ErrorResponse("busy");

                int packLen = r[1] - 1;
                if (packLen != 6)
                    throw new ErrorResponse("unexpected response");

                int n = 2 + packLen + 1 - r.Length;
                if (n > 0)
                    r = r.Concat(await _channel.ReadAsync(n)).ToArray();
            }
            finally
            {
                _channel._lock.Release();
            }

            r = r[..(2 + packLen + 1)];
            _channel.EnsureCheckSumMatch(r);
            return r[2..];
        }

        private async Task<byte[]> CmdC4Async(byte addr, byte op, byte[] data)
        {
            var q = new List<byte> { 0x16, 0xE4, addr, op, 0, (byte)data.Length };
            q.AddRange(data);
            q.Add(Utils.CheckSum(data));

            await _channel._lock.WaitAsync();
            try
            {
                await _channel.WriteAsync(q.ToArray());
                var r = await _channel.ReadUntilAsync(2, addr, 0x16);
                if (r[0] == 0x16 && r[1] == 0x15)
                    throw new ErrorResponse("check sum not match");

                if (r.Length < 3)
                    r = r.Concat(await _channel.ReadSomeAsync(1)).ToArray();

                if (r[0] == addr && r[1] == 0 && r[2] == (byte)(~addr & 0xFF))
                    throw new ErrorResponse("busy");

                int packLen = r[1] - 1;
                if (packLen == 1)
                {
                    if (r[2] == 0xFF)
                        throw new ErrorResponse("invalid param");
                    else if (r[2] == 0xFE)
                        throw new ErrorResponse("invalid pack len");
                }

                int n = 2 + packLen + 1 - r.Length;
                if (n > 0)
                    r = r.Concat(await _channel.ReadAsync(n)).ToArray();
            }
            finally
            {
                _channel._lock.Release();
            }

            r = r[..(2 + packLen + 1)];
            _channel.EnsureCheckSumMatch(r);
            return r[2..(2 + packLen)];
        }

        public void Dispose()
        {
            _channel?.Dispose();
        }
    }
} 