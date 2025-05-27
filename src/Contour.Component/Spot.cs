namespace SevenSeals.Tss.Contour;

public class Spot
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
    private int _recoverState;
    private int _state;

    private const int RecoverNone = 0;
    private const int RecoverAlive = 1;
    private const int RecoverDead = 2;

    private const int StateStateless = 1;
    private const int StateAutonomicPolling = 2;
    private const int StateComplex = 3;

    private enum MemType
    {
        None,
        RAM,
        EEPROM
    }

    private enum MemOp
    {
        None,
        Off,
        Read,
        Write
    }

    public class Error : Exception
    {
        public Error(Spot spot, string className, string message)
            : base($"{className}: {message}")
        {
            Spot = spot;
        }

        public Spot Spot { get; }
    }

    public Spot(Channel channel, byte addr)
    {
        _channel = channel;
        _addr = addr;
        _polling = false;
        _progId = 0;
        _progVer = 0;
        _progVerCnt = 0;
        _chipsActivated = new HashSet<ulong>();
        _recoverState = RecoverNone;
        _state = StateStateless;

        // Initialize timers
        _aliveTimer = new Timer(OnAliveTimer, null, Timeout.Infinite, Timeout.Infinite);
        _deadTimer = new Timer(OnDeadTimer, null, Timeout.Infinite, Timeout.Infinite);
        _stateTimer = new Timer(OnStateTimer, null, Timeout.Infinite, Timeout.Infinite);
    }

    public string Name => $"Controller_{_addr}";
    public byte State => (byte)_state;
    public byte ProgId => _progId;
    public short ProgVer => _progVer;
    public bool IsAlarm => _isAlarm ?? false;
    public int SerNum { get; private set; }

    public void PollOn(bool isAuto, bool isReliable)
    {
        lock (_channel)
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
        lock (_channel)
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

    public void EventsInfo(out int capacity, out int count)
    {
        lock (_channel)
        {
            if (_progVer == 0)
            {
                EventsInfo201(out capacity, out count);
            }
            else
            {
                EventsInfoNormal(out capacity, out count);
            }
        }
    }

    public void KeysInfo(out int capacity, out int count)
    {
        lock (_channel)
        {
            if (_progVer == 0)
            {
                KeysInfo201(out capacity, out count);
            }
            else
            {
                KeysInfoNormal(out capacity, out count);
            }
        }
    }

    public void PortsInfo(byte[] ports)
    {
        lock (_channel)
        {
            if (_progVer < 11)
            {
                throw new Error(this, "Feature", "Unsupported feature");
            }

            byte[] buf = new byte[4];
            int respLen = Execute4C(0x40, buf, false);
            if (respLen != 1)
            {
                throw new Error(this, "Protocol", "Unexpected response");
            }

            ExpandMask(ports, buf[2]);
        }
    }

    public void RelayOn(int port, int interval, bool suppressDoorEvent)
    {
        if (port < 1 || port > 8)
            throw new ArgumentOutOfRangeException(nameof(port), "Port must be between 1 and 8");
        if (interval < 0 || interval > 31)
            throw new ArgumentOutOfRangeException(nameof(interval), "Interval must be between 0 and 31");

        lock (_channel)
        {
            if (_progVer >= 33)
            {
                var cmd = new Command(this, 0x11, 3, 2);
                cmd[0] = _addr;
                cmd[1] = suppressDoorEvent ? (byte)((port - 1) | 192) : (byte)((port - 1) | 64);
                cmd[2] = (byte)(interval * 4);
                cmd.Execute();
            }
            else
            {
                byte[] cmd = new byte[] { 0x16, suppressDoorEvent ? (byte)0x6A : (byte)0x69, _addr, (byte)((interval << 3) | (port - 1)) };
                _channel.Write(cmd);
                _channel.Write(cmd); // Send twice
            }
        }
    }

    public void RelayOff(int port)
    {
        if (port < 1 || port > 8)
            throw new ArgumentOutOfRangeException(nameof(port), "Port must be between 1 and 8");

        lock (_channel)
        {
            if (_progVer >= 33)
            {
                var cmd = new Command(this, 0x10, 2, 1);
                cmd[0] = _addr;
                cmd[1] = (byte)(1 << (port - 1));
                cmd.Execute();
            }
            else
            {
                byte[] cmd = new byte[] { 0x16, 0x6B, _addr, (byte)(1 << (port - 1)) };
                _channel.Write(cmd);
                _channel.Write(cmd); // Send twice
            }
        }
    }

    private void OnAliveTimer(object state)
    {
        // Implement alive timer logic
    }

    private void OnDeadTimer(object state)
    {
        // Implement dead timer logic
    }

    private void OnStateTimer(object state)
    {
        // Implement state timer logic
    }

    private void SetState(int state)
    {
        _state = state;
    }

    private void ReadEvt2(bool isAuto)
    {
        byte[] cmd = new byte[] { 0x16, isAuto ? (byte)0x3A : (byte)0x2A, _addr };
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

    private void EventsInfo201(out int capacity, out int count)
    {
        capacity = ReadRPD(0x53) + ReadRPD(0x54) * 256;
        count = ReadRPD(0x34) + ReadRPD(0x35) * 256;
    }

    private void EventsInfoNormal(out int capacity, out int count)
    {
        byte[] buf = new byte[10];
        int respLen = Execute4C(1, buf, true);
        if (!((buf[2] == 2 && respLen == 5) || (buf[2] == 3 && respLen == 7)))
        {
            throw new Error(this, "Protocol", "Unexpected response");
        }

        capacity = VarVal(buf, 2, 1);
        count = VarVal(buf, 2, 1 + buf[2]);
    }

    private void KeysInfo201(out int capacity, out int count)
    {
        int offBeg = ReadRPD(0x4E) * 256;
        short pageCount = ReadRPD(0x4F);
        capacity = pageCount * 31;
        byte[] buf = new byte[6 + 8];
        count = 0;

        for (short pageIdx = 0; pageIdx != pageCount; ++pageIdx)
        {
            ReadMem(offBeg + (pageIdx * 256), buf, 0, buf.Length);
            if (IsDallas(buf, 5))
            {
                count += buf[12];
            }
            else
            {
                break;
            }
        }
    }

    private void KeysInfoNormal(out int capacity, out int count)
    {
        var kbi = new KBInfo(this);
        capacity = kbi.Capacity;
        count = kbi.Count;
    }

    private byte ReadRPD(byte addr)
    {
        // Implement RPD reading logic
        return 0;
    }

    private int VarVal(byte[] buf, int offset, int size)
    {
        // Implement variable value reading logic
        return 0;
    }

    private bool IsDallas(byte[] buf, int offset)
    {
        return buf[offset] == 'D' && buf[offset + 1] == 'A' && buf[offset + 2] == 'L' &&
               buf[offset + 3] == 'L' && buf[offset + 4] == 'A' && buf[offset + 5] == 'S';
    }

    private void ReadMem(int offset, byte[] buf, int bufOffset, int count)
    {
        // Implement memory reading logic
    }

    private int Execute4C(byte op, byte[] buf, bool checkOp)
    {
        buf[0] = 0x16;
        buf[1] = 0x6C;
        buf[2] = _addr;
        buf[3] = op;
        _channel.Write(buf, 0, 4);
        return ReadPack(buf, buf.Length, checkOp);
    }

    private int ReadPack(byte[] buf, int size, bool checkOp)
    {
        int read = 0, len = 0;
        while (true)
        {
            int r = _channel.Read(buf, read, size - read);
            if (r == 0)
                throw new Error(this, "Timeout", $"No response in {_channel.ResponseTimeout} msec");

            read += r;
            if (len == 0)
                len = CheckPack(buf, read, checkOp);

            if (len != 0 && (read - 3) >= len)
                return len;

            if (size == read)
                throw new Error(this, "Protocol", "Unexpected response");
        }
    }

    private int CheckPack(byte[] buf, int size, bool checkOp)
    {
        int len = 0;

        if (size > 3)
        {
            if (buf[0] != _addr)
                throw new Error(this, "Protocol", "Unexpected response");

            len = buf[1] - 1; // packLength
            if ((size - 3) >= len)
            {
                int x = len + 2;
                if (CS8(buf, x) != buf[x])
                    throw new Error(this, "Error", "Invalid checksum");

                if (checkOp && len == 1)
                {
                    switch (buf[2])
                    {
                        case 0xFE:
                            throw new Error(this, "Error", "Invalid pack length");
                        case 0xFF:
                            throw new Error(this, "Error", "Illegal operation");
                    }
                }
            }
        }
        else if (size > 2 && buf[0] == _addr && buf[1] == 0 && buf[2] == (byte)~_addr)
        {
            throw new Error(this, "Error", "Busy");
        }
        else if (size > 1 && buf[0] == 0x16 && buf[1] == 0x15)
        {
            throw new Error(this, "Error", "Invalid checksum");
        }

        return len;
    }

    private static byte CS8(byte[] buf, int size)
    {
        byte ret = buf[0];
        for (int i = 1; i != size; ++i)
            ret += buf[i];
        return ret;
    }

    private void ExpandMask(byte[] ports, byte mask)
    {
        for (int i = 0; i < 8; i++)
        {
            ports[i] = (byte)((mask & (1 << i)) != 0 ? 1 : 0);
        }
    }

    private class Command
    {
        private readonly Spot _spot;
        private readonly byte _op;
        private readonly byte _osize;
        private readonly byte _isize;
        private readonly byte[] _buf;

        public Command(Spot spot, byte op, byte osize, byte isize)
        {
            _spot = spot;
            _op = op;
            _osize = osize;
            _isize = isize;
            _buf = new byte[Math.Max(osize, isize) + 7];
        }

        public byte this[byte index]
        {
            get => _buf[6 + index];
            set => _buf[6 + index] = value;
        }

        public int Execute(bool checkOp = true)
        {
            // Implement command execution logic
            return 0;
        }
    }

    private class KBInfo
    {
        public int Capacity { get; }
        public int Count { get; }

        public KBInfo(Spot spot)
        {
            // Implement KB info reading logic
        }
    }
}
