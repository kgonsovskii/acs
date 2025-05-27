using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServCont
{
    public class Controller
    {
        private readonly Channel _channel;
        private readonly byte _addr;
        private bool _polling;
        private bool _autonomic;
        private byte _progId;
        private short _progVer;
        private int _progVerCnt;
        private bool? _isAlarm;
        private HashSet<ulong> _chipsActivated;
        private string _lastErrMsg;
        private Timer _aliveTimer;
        private Timer _deadTimer;
        private Timer _stateTimer;
        private byte _recoverState;
        private byte _state;

        // Constants
        private const byte RecoverNone = 0;
        private const byte RecoverAlive = 1;
        private const byte RecoverDead = 2;

        private const byte StateStateless = 1;
        private const byte StateAutonomicPolling = 2;
        private const byte StateComplex = 3;

        // Memory types
        private enum MemType
        {
            None,
            RAM,
            EEPROM
        }

        // Memory operations
        private enum MemOp
        {
            None,
            Off,
            Read,
            Write
        }

        public Controller(Channel channel, byte addr)
        {
            _channel = channel;
            _addr = addr;
            _polling = false;
            _progId = 0;
            _progVer = 0;
            _progVerCnt = 0;
            _aliveTimer = new Timer(OnAliveTimer, null, Timeout.Infinite, Timeout.Infinite);
            _deadTimer = new Timer(OnDeadTimer, null, Timeout.Infinite, Timeout.Infinite);
            _stateTimer = new Timer(OnStateTimer, null, Timeout.Infinite, Timeout.Infinite);
            _recoverState = RecoverNone;
            _state = StateStateless;
            _chipsActivated = new HashSet<ulong>();
        }

        public string Name => $"Controller {_addr}";

        public byte State => _state;

        public void PollOn(bool isAuto, bool isReliable)
        {
            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                _polling = true;
                _deadTimer.Change(Timeout.Infinite, Timeout.Infinite);
                _aliveTimer.Change(Timeout.Infinite, Timeout.Infinite);
                _recoverState = RecoverNone;
                _autonomic = isAuto;
            }
        }

        public void PollOff(bool forceAuto)
        {
            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                _polling = false;
                _deadTimer.Change(Timeout.Infinite, Timeout.Infinite);
                _aliveTimer.Change(Timeout.Infinite, Timeout.Infinite);
                _recoverState = RecoverNone;

                if (forceAuto && _channel.IsReady)
                {
                    ReadEvt2(true);
                    SetState(StateStateless);
                }
                else
                {
                    _stateTimer.Change(3000, Timeout.Infinite);
                }
            }
        }

        public byte ProgId
        {
            get
            {
                using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
                {
                    return GetProgId();
                }
            }
        }

        public short ProgVer
        {
            get
            {
                using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
                {
                    if (GetProgVer() == 0)
                        throw new ControllerException(this, "Feature", "Unsupported feature");
                    return _progVer;
                }
            }
        }

        public bool IsAlarm
        {
            get
            {
                using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
                {
                    return GetIsAlarm();
                }
            }
        }

        public int SerNum
        {
            get
            {
                using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
                {
                    if (GetProgVer() == 0)
                        throw new ControllerException(this, "Feature", "Unsupported feature");
                    return GetSerNum();
                }
            }
        }

        public void WriteKey(byte[] key)
        {
            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                if (GetProgVer() == 0)
                    WriteKey201(key);
                else
                    WriteKey(key);
            }
        }

        public void EraseKey(byte[] key)
        {
            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                if (GetProgVer() == 0)
                    throw new ControllerException(this, "Feature", "Unsupported feature");
                EraseKey(key);
            }
        }

        public void EraseAllKeys()
        {
            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                if (GetProgVer() == 0)
                    EraseAllKeys201();
                else
                    EraseAllKeys();
            }
        }

        public bool KeyExists(byte[] key, out byte ports, out byte persCat, out bool suppressDoorEvent, out bool openEvenComplex, out bool isSilent)
        {
            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                if (GetProgVer() == 0)
                    throw new ControllerException(this, "Feature", "Unsupported feature");

                byte[] cmd = new byte[14];
                cmd[0] = 0x16;
                cmd[1] = 0x6C;
                cmd[2] = _addr;
                cmd[3] = 2;
                ReverseCopyKey(cmd, 4, key);
                _channel.Write(cmd, 0, 14);

                byte[] response = new byte[14];
                int len = ReadPack(response, true);

                bool ret = (len == 8 && 
                           response[0] == key[5] && 
                           response[1] == key[4] && 
                           response[2] == key[3] && 
                           response[3] == key[2] && 
                           response[4] == key[1] && 
                           response[5] == key[0]);

                if (ret)
                {
                    DecodeKeyAttr(response, 6, out ports, out persCat, out suppressDoorEvent, out openEvenComplex, out isSilent);
                }
                else
                {
                    ports = 0;
                    persCat = 0;
                    suppressDoorEvent = false;
                    openEvenComplex = false;
                    isSilent = false;
                }

                return ret;
            }
        }

        private byte GetProgId()
        {
            if (_progId == 0)
            {
                byte[] cmd = { 0x16, 0x20, _addr };
                _channel.Write(cmd);
                var response = _channel.Read(1);
                if (response.Length == 0)
                    throw new ControllerException(this, "Timeout", $"No response in {_channel.ResponseTimeout} msec");
                _progId = response[0];
            }
            return _progId;
        }

        private short GetProgVer()
        {
            if (_progVer == 0 && _progVerCnt < 3)
            {
                try
                {
                    byte[] buf = new byte[5];
                    if (Execute4C(0x10, buf, true) != 2)
                        throw new ControllerException(this, "Protocol", "Unexpected response");
                    _progVer = BitConverter.ToInt16(buf, 2);
                }
                catch
                {
                    if (GetProgId() == 0x9C)
                        throw;
                    _progVerCnt++;
                }
            }
            return _progVer;
        }

        private int GetSerNum()
        {
            byte[] buf = new byte[7];
            if (Execute4C(0x20, buf, true) != 4)
                throw new ControllerException(this, "Protocol", "Unexpected response");
            return BitConverter.ToInt32(buf, 2);
        }

        private bool GetIsAlarm()
        {
            if (!_isAlarm.HasValue)
            {
                byte[] buf = new byte[4];
                if (Execute4C(0x30, buf, true) != 1)
                    throw new ControllerException(this, "Protocol", "Unexpected response");
                _isAlarm = (buf[2] & 1) != 0;
            }
            return _isAlarm.Value;
        }

        private int Execute4C(byte op, byte[] buf, bool checkOp)
        {
            buf[0] = 0x16;
            buf[1] = 0x6C;
            buf[2] = _addr;
            buf[3] = op;
            _channel.Write(buf, 0, 4);
            return ReadPack(buf, checkOp);
        }

        private int ReadPack(byte[] buf, bool checkOp)
        {
            int read = 0;
            int len = 0;
            while (true)
            {
                int r = _channel.Read(buf, read, buf.Length - read);
                if (r == 0)
                    throw new ControllerException(this, "Timeout", $"No response in {_channel.ResponseTimeout} msec");
                read += r;

                if (len == 0)
                    len = CheckPack(buf, read, checkOp);

                if (len != 0 && (read - 3) >= len)
                    return len;

                if (read == buf.Length)
                    throw new ControllerException(this, "Protocol", "Unexpected response");
            }
        }

        private int CheckPack(byte[] buf, int size, bool checkOp)
        {
            if (size > 3)
            {
                if (buf[0] != _addr)
                    throw new ControllerException(this, "Protocol", "Unexpected response");

                int len = buf[1] - 1;
                if ((size - 3) >= len)
                {
                    int x = len + 2;
                    if (CalculateCS8(buf, x) != buf[x])
                        throw new ControllerException(this, "Error", "Invalid checksum");

                    if (checkOp && len == 1)
                    {
                        switch (buf[2])
                        {
                            case 0xFE:
                                throw new ControllerException(this, "Error", "Invalid pack length");
                            case 0xFF:
                                throw new ControllerException(this, "Error", "Illegal operation");
                        }
                    }
                }
            }
            else if (size > 2 && buf[0] == _addr && buf[1] == 0 && buf[2] == (byte)~_addr)
            {
                throw new ControllerException(this, "Error", "Busy");
            }
            else if (size > 1 && buf[0] == 0x16 && buf[1] == 0x15)
            {
                throw new ControllerException(this, "Error", "Invalid checksum");
            }

            return len;
        }

        private static byte CalculateCS8(byte[] buf, int size)
        {
            byte ret = buf[0];
            for (int i = 1; i != size; ++i)
                ret += buf[i];
            return ret;
        }

        private void SetState(byte state)
        {
            _state = state;
        }

        private void ReadEvt2(bool isAuto)
        {
            byte[] cmd = { 0x16, (byte)(isAuto ? 0x3A : 0x2A), _addr };
            byte[] buf = new byte[17];
            _channel.Write(cmd);
            int read = 0;
            while (true)
            {
                int r = _channel.Read(buf, read, buf.Length - read);
                if (r == 0)
                    break;
                read += r;
                if (read == buf.Length)
                    break;
                else if (read == 3 && buf[0] == _addr && buf[1] == 0)
                {
                    if (buf[2] == _addr) // No events?
                        break;
                    else if (buf[2] == (byte)~_addr) // Busy?
                        break;
                }
                else if (read == 4 && buf[1] == _addr && buf[2] == 0 && buf[3] == _addr)
                    break;
            }
        }

        private void OnAliveTimer(object state)
        {
            // Implementation for alive timer callback
        }

        private void OnDeadTimer(object state)
        {
            // Implementation for dead timer callback
        }

        private void OnStateTimer(object state)
        {
            // Implementation for state timer callback
        }

        private void WriteKey(byte[] key)
        {
            EraseKey(key);
            byte[] cmd = new byte[14];
            cmd[0] = 0x16;
            cmd[1] = 0x6C;
            cmd[2] = _addr;
            cmd[3] = 1;
            PackKey(cmd, 4, key);
            _channel.Write(cmd, 0, 14);
            ReadPack(cmd, true);
        }

        private void WriteKey201(byte[] key)
        {
            int offBeg = ReadRPD(0x4E) * 256;
            short pageCount = ReadRPD(0x4F);
            bool noSpace = true;
            byte[] buf = new byte[23];

            for (short pageIdx = 0; pageIdx != pageCount; ++pageIdx)
            {
                ReadMem(offBeg + (pageIdx * 256), buf, 0, 23);
                if (IsDallas(buf, 5))
                {
                    byte numKeys = buf[12];
                    if (numKeys < 31)
                    {
                        noSpace = false;
                        PackKey(buf, 6, key);
                        WriteMem(offBeg + (pageIdx * 256) + (numKeys * 8) + 8, buf, 6, 8);
                        buf[6] = (byte)(numKeys + 1);
                        WriteMem(offBeg + (pageIdx * 256) + 7, buf, 6, 1);
                        break;
                    }
                }
                else
                {
                    noSpace = false;
                    Array.Copy(Encoding.ASCII.GetBytes("DALLAS"), 0, buf, 6, 6);
                    buf[12] = 0;
                    buf[13] = 1;
                    PackKey(buf, 14, key);
                    WriteMem(offBeg + (pageIdx * 256), buf, 6, 16);
                    break;
                }
            }

            if (noSpace)
                throw new ControllerException(this, "Error", "No space");
        }

        private void EraseKey(byte[] key)
        {
            byte[] cmd = new byte[14];
            cmd[0] = 0x16;
            cmd[1] = 0x6C;
            cmd[2] = _addr;
            cmd[3] = 0;
            ReverseCopyKey(cmd, 4, key);
            _channel.Write(cmd, 0, 14);
            ReadPack(cmd, true);
        }

        private void EraseAllKeys()
        {
            byte[] cmd = new byte[14];
            cmd[0] = 0x16;
            cmd[1] = 0x6C;
            cmd[2] = _addr;
            cmd[3] = 0x81;
            cmd[4] = 0x81;
            cmd[5] = _addr;
            BitConverter.GetBytes(GetSerNum()).CopyTo(cmd, 6);
            _channel.Write(cmd, 0, 14);
            ReadPack(cmd, true);
        }

        private void EraseAllKeys201()
        {
            int offBeg = ReadRPD(0x4E) * 256;
            short pageCount = ReadRPD(0x4F);
            byte[] buf = new byte[15];
            Array.Clear(buf, 6, 8);
            for (short pageIdx = 0; pageIdx != pageCount; ++pageIdx)
            {
                WriteMem(offBeg + (pageIdx * 256), buf, 6, 8);
            }
        }

        private static void PackKey(byte[] dest, int offset, byte[] key)
        {
            for (int i = 0; i < 6; i++)
            {
                dest[offset + i] = key[i];
            }
        }

        private static void ReverseCopyKey(byte[] dest, int offset, byte[] key)
        {
            dest[offset] = key[5];
            dest[offset + 1] = key[4];
            dest[offset + 2] = key[3];
            dest[offset + 3] = key[2];
            dest[offset + 4] = key[1];
            dest[offset + 5] = key[0];
        }

        private static void DecodeKeyAttr(byte[] data, int offset, out byte ports, out byte persCat, out bool suppressDoorEvent, out bool openEvenComplex, out bool isSilent)
        {
            ports = data[offset];
            persCat = data[offset + 1];
            suppressDoorEvent = (data[offset + 2] & 1) != 0;
            openEvenComplex = (data[offset + 2] & 2) != 0;
            isSilent = (data[offset + 2] & 4) != 0;
        }

        private static bool IsDallas(byte[] data, int offset)
        {
            return data[offset] == 'D' &&
                   data[offset + 1] == 'A' &&
                   data[offset + 2] == 'L' &&
                   data[offset + 3] == 'L' &&
                   data[offset + 4] == 'A' &&
                   data[offset + 5] == 'S';
        }

        private byte ReadRPD(byte addr)
        {
            byte[] cmd = new byte[4];
            cmd[0] = 0x16;
            cmd[1] = 0x20;
            cmd[2] = _addr;
            cmd[3] = addr;
            _channel.Write(cmd);
            var response = _channel.Read(1);
            if (response.Length == 0)
                throw new ControllerException(this, "Timeout", $"No response in {_channel.ResponseTimeout} msec");
            return response[0];
        }

        private void ReadMem(int offset, byte[] buf, int bufOffset, int count)
        {
            byte[] cmd = new byte[6];
            cmd[0] = 0x16;
            cmd[1] = (byte)(0xB0 | (offset >> 16));
            cmd[2] = _addr;
            cmd[3] = (byte)offset;
            cmd[4] = (byte)(offset >> 8);
            cmd[5] = (byte)(count - 6);
            _channel.Write(cmd);

            int read = 0;
            while (true)
            {
                int r = _channel.Read(buf, bufOffset + read, count - read);
                if (r == 0)
                    throw new ControllerException(this, "Timeout", $"No response in {_channel.ResponseTimeout} msec");
                read += r;

                if (read > 1 && buf[bufOffset] == 0x16)
                {
                    switch (buf[bufOffset + 1])
                    {
                        case 4:
                            throw new ControllerException(this, "Error", "Can't read memory");
                        case 0x18:
                            throw new ControllerException(this, "Error", "Busy");
                    }

                    if (read > 4)
                    {
                        if (!((buf[bufOffset + 1] == 0x80 || buf[bufOffset + 1] == 0x83) &&
                              buf[bufOffset + 2] == cmd[3] &&
                              buf[bufOffset + 3] == cmd[4] &&
                              buf[bufOffset + 4] == cmd[5]))
                            throw new ControllerException(this, "Protocol", "Unexpected response");

                        if (read == count)
                        {
                            if (buf[bufOffset + count - 1] != CalculateCS8(buf, bufOffset + 5, count - 6))
                                throw new ControllerException(this, "Error", "Invalid checksum");
                            break;
                        }
                    }
                }
            }
        }

        private void WriteMem(int offset, byte[] buf, int bufOffset, int count)
        {
            byte[] cmd = new byte[count + 7];
            cmd[0] = 0x16;
            cmd[1] = (byte)(0xF0 | (offset >> 16));
            cmd[2] = _addr;
            cmd[3] = (byte)offset;
            cmd[4] = (byte)(offset >> 8);
            cmd[5] = (byte)count;
            Array.Copy(buf, bufOffset, cmd, 6, count);
            cmd[count + 6] = CalculateCS8(cmd, 6, count);

            _channel.Write(cmd, 0, count + 7);
            int read = 0;
            do
            {
                int r = _channel.Read(cmd, read, count + 7 - read);
                if (r == 0)
                    throw new ControllerException(this, "Timeout", $"No response in {_channel.ResponseTimeout} msec");
                read += r;

                if (read > 1)
                {
                    if (0x16 != cmd[0])
                        throw new ControllerException(this, "Protocol", "Unexpected response");

                    switch (cmd[1])
                    {
                        case 4:
                            throw new ControllerException(this, "Error", "Invalid mode");
                        case 6:
                            break;
                        case 0x15:
                            throw new ControllerException(this, "Error", "Invalid checksum");
                        case 0x18:
                            throw new ControllerException(this, "Error", "Busy");
                        case 0x1B:
                            throw new ControllerException(this, "Error", "Invalid mode or offset");
                        default:
                            throw new ControllerException(this, "Protocol", "Unexpected response");
                    }
                }
            } while (read < 2);
        }

        public void RelayOn(int port, int interval, bool suppressDoorEvent)
        {
            if (port < 1 || port > 8)
                throw new ArgumentOutOfRangeException(nameof(port), "Port must be between 1 and 8");
            if (interval < 0 || interval > 31)
                throw new ArgumentOutOfRangeException(nameof(interval), "Interval must be between 0 and 31");

            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                if (GetProgVer() >= 33)
                {
                    byte[] cmd = new byte[5];
                    cmd[0] = 0x16;
                    cmd[1] = 0x6C;
                    cmd[2] = _addr;
                    cmd[3] = 0x11;
                    cmd[4] = suppressDoorEvent ? (byte)((port - 1) | 192) : (byte)((port - 1) | 64);
                    cmd[5] = (byte)(interval * 4);
                    _channel.Write(cmd);
                    ReadPack(cmd, true);
                }
                else
                {
                    byte[] cmd = new byte[4];
                    cmd[0] = 0x16;
                    cmd[1] = suppressDoorEvent ? (byte)0x6A : (byte)0x69;
                    cmd[2] = _addr;
                    cmd[3] = (byte)((interval << 3) | (port - 1));
                    _channel.Write(cmd);
                    _channel.Write(cmd); // Send twice for reliability
                }
            }
        }

        public void RelayOff(int port)
        {
            if (port < 1 || port > 8)
                throw new ArgumentOutOfRangeException(nameof(port), "Port must be between 1 and 8");

            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                if (GetProgVer() >= 33)
                {
                    byte[] cmd = new byte[6];
                    cmd[0] = 0x16;
                    cmd[1] = 0x6C;
                    cmd[2] = _addr;
                    cmd[3] = 0x10;
                    cmd[4] = (byte)(1 << (port - 1));
                    _channel.Write(cmd);
                    ReadPack(cmd, true);
                }
                else
                {
                    byte[] cmd = new byte[4];
                    cmd[0] = 0x16;
                    cmd[1] = 0x6B;
                    cmd[2] = _addr;
                    cmd[3] = (byte)(1 << (port - 1));
                    _channel.Write(cmd);
                    _channel.Write(cmd); // Send twice for reliability
                }
            }
        }

        public void Timer(int interval)
        {
            if (interval < 0 || interval > 255)
                throw new ArgumentOutOfRangeException(nameof(interval), "Interval must be between 0 and 255");

            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                byte[] cmd = new byte[4];
                cmd[0] = 0x16;
                cmd[1] = 0x6D;
                cmd[2] = _addr;
                cmd[3] = (byte)interval;
                _channel.Write(cmd);
            }
        }

        public void GenerateTimerEvents(int count)
        {
            if (count < 1 || count > 0xFFFF)
                throw new ArgumentOutOfRangeException(nameof(count), "Count must be between 1 and 65535");

            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                if (GetProgVer() < 270) // v1.14
                    throw new ControllerException(this, "Feature", "Unsupported feature");

                byte[] cmd = new byte[6];
                cmd[0] = 0x16;
                cmd[1] = 0xAF;
                cmd[2] = _addr;
                BitConverter.GetBytes((short)count).CopyTo(cmd, 3);
                cmd[5] = CalculateCS8(cmd, 0, 5);
                _channel.Write(cmd);
                var response = _channel.Read(1);
                if (response.Length == 0)
                    throw new ControllerException(this, "Timeout", $"No response in {_channel.ResponseTimeout} msec");
            }
        }

        public void ReadClock(byte[] timestamp)
        {
            if (timestamp == null || timestamp.Length < 6)
                throw new ArgumentException("Timestamp buffer must be at least 6 bytes", nameof(timestamp));

            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                if (GetProgVer() == 0)
                    throw new ControllerException(this, "Feature", "Unsupported feature");

                byte[] cmd = new byte[4];
                cmd[0] = 0x16;
                cmd[1] = 0x6E;
                cmd[2] = _addr;
                cmd[3] = 0x7F;
                _channel.Write(cmd);

                byte[] response = new byte[10];
                if (ReadPack(response, true) != 7)
                    throw new ControllerException(this, "Protocol", "Unexpected response");

                if ((response[2] & 0x80) != 0)
                    throw new ControllerException(this, "Error", "Erroneous clock");

                timestamp[5] = BcdToBin(response[2]);
                timestamp[4] = BcdToBin(response[3]);
                timestamp[3] = BcdToBin(response[4]);
                timestamp[2] = BcdToBin(response[6]);
                timestamp[1] = BcdToBin(response[7]);
                timestamp[0] = BcdToBin(response[8]);
            }
        }

        public void WriteClockDate(byte[] date)
        {
            if (date == null || date.Length < 3)
                throw new ArgumentException("Date buffer must be at least 3 bytes", nameof(date));
            if (date[1] < 1 || date[1] > 12)
                throw new ArgumentOutOfRangeException(nameof(date), "Month must be between 1 and 12");
            if (date[2] < 1 || date[2] > 31)
                throw new ArgumentOutOfRangeException(nameof(date), "Day must be between 1 and 31");

            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                if (GetProgVer() == 0)
                    throw new ControllerException(this, "Feature", "Unsupported feature");

                byte[] cmd = new byte[6];
                cmd[0] = 0x16;
                cmd[1] = 0xA9;
                cmd[2] = _addr;
                cmd[3] = BinToBcd(date[2]);
                cmd[4] = BinToBcd(date[1]);
                cmd[5] = BinToBcd(date[0]);
                _channel.Write(cmd);
            }
        }

        public void WriteClockTime(byte[] time)
        {
            if (time == null || time.Length < 3)
                throw new ArgumentException("Time buffer must be at least 3 bytes", nameof(time));
            if (time[0] > 23)
                throw new ArgumentOutOfRangeException(nameof(time), "Hour must be between 0 and 23");
            if (time[1] > 59)
                throw new ArgumentOutOfRangeException(nameof(time), "Minute must be between 0 and 59");
            if (time[2] > 59)
                throw new ArgumentOutOfRangeException(nameof(time), "Second must be between 0 and 59");

            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                byte[] cmd = new byte[6];
                cmd[0] = 0x16;
                cmd[1] = 0xA8;
                cmd[2] = _addr;
                cmd[3] = BinToBcd(time[2]);
                cmd[4] = BinToBcd(time[1]);
                cmd[5] = BinToBcd(time[0]);
                _channel.Write(cmd);
            }
        }

        public void EraseTimetable()
        {
            using (var scopedLock = new Channel.ExtCmdScopedLock(_channel))
            {
                if (GetProgId() != 0x9C)
                    throw new ControllerException(this, "Feature", "Unsupported feature");

                SetMemMode(MemType.RAM, 0, MemOp.Write, 1);
                byte[] buf = new byte[11];
                buf[6] = (byte)'X';
                buf[7] = (byte)'X';
                buf[8] = (byte)'X';
                buf[9] = (byte)'X';
                WriteMem(0, GetRAMInfo().TTfirstBlock * GetRAMInfo().BlockSizeBytes + 28, buf, 6, 4);
            }
        }

        private class RAMInfo
        {
            public byte Type { get; set; }
            public byte BlockSizePages { get; set; }
            public short BlockSizeBytes => (short)(BlockSizePages * 256);
            public short BlockCount { get; set; }
            public short IBufSizeBytes { get; set; }
            public short OBufSizeBytes { get; set; }
            public byte KBfirstBlock { get; set; }
            public byte TTfirstBlock { get; set; }
            public byte TTblockCount { get; set; }
        }

        private RAMInfo GetRAMInfo()
        {
            byte[] buf = new byte[18];
            ReadMem(0, buf, 0, 18);
            return new RAMInfo
            {
                Type = buf[2],
                BlockSizePages = buf[3],
                BlockCount = (short)(buf[4] != 0 ? buf[4] : 256),
                IBufSizeBytes = (short)(buf[11] != 0 ? buf[11] : 256),
                OBufSizeBytes = (short)(buf[12] != 0 ? buf[12] : 256),
                KBfirstBlock = buf[13],
                TTfirstBlock = buf[15],
                TTblockCount = buf[16]
            };
        }

        private void SetMemMode(MemType mem, byte bank, MemOp op, byte numOps = 0)
        {
            if (numOps > 15)
                throw new ArgumentOutOfRangeException(nameof(numOps), "Memory operation count must be between 0 and 15");

            byte[] cmd = new byte[6];
            cmd[0] = 0x16;
            cmd[1] = 0xA4;
            cmd[2] = _addr;

            byte x = 0;
            switch (mem)
            {
                case MemType.RAM:
                    x = 1;
                    break;
                case MemType.EEPROM:
                    x = 3;
                    break;
                default:
                    throw new ControllerException(this, "Error", "Unknown memory type");
            }
            x <<= 4;

            switch (op)
            {
                case MemOp.Off:
                    break;
                case MemOp.Read:
                    break;
                case MemOp.Write:
                    x |= 128;
                    break;
                default:
                    throw new ControllerException(this, "Error", "Unknown memory operation");
            }

            cmd[3] = (byte)((numOps & 15) | x);
            cmd[4] = bank;
            cmd[5] = CalculateCS8(cmd, 3, 2);

            _channel.Write(cmd);
            int packLen = ReadPack(cmd, true);
            if (packLen != 3)
                throw new ControllerException(this, "Protocol", "Unexpected response");

            if ((cmd[2] & 8) != 0)
                throw new ControllerException(this, "Error", "Writing access denied");
            if ((cmd[2] & 4) != 0)
                throw new ControllerException(this, "Error", "Invalid bank");
            if ((cmd[2] & 2) != 0)
                throw new ControllerException(this, "Error", "Unsupported address space");
            if ((cmd[2] & 1) != 0)
                throw new ControllerException(this, "Error", "Unknown address space");
        }

        private static byte BcdToBin(byte bcd)
        {
            return (byte)(((bcd >> 4) * 10) + (bcd & 0x0F));
        }

        private static byte BinToBcd(byte bin)
        {
            return (byte)(((bin / 10) << 4) | (bin % 10));
        }
    }

    public class ControllerException : Exception
    {
        public Controller Controller { get; }
        public string ClassName { get; }

        public ControllerException(Controller controller, string className, string message)
            : base(message)
        {
            Controller = controller;
            ClassName = className;
        }
    }
} 