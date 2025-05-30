namespace SevenSeals.Tss.Contour;

public partial class Spot
{
    private byte? _progId;
    private short? _progVer;
    private int? _sernum;

    public byte State => (byte)_state;
    public byte ProgId => GetProgId();
    public short ProgVer => GetProgVer();
    public int SerNum => GetSerNum();

    public bool IsAlarm => _isAlarm ?? false;

    private void CheckInput(int result)
    {
        //nothing
    }

    public byte GetProgId()
    {
        lock (Channel)
        {
            if (_progId != null)
                return (byte)_progId;

            byte[] cmd = { 0x16, 0x20, Address };
            Channel.Write(cmd, cmd.Length);
            byte[] response = new byte[1];
            int result = Channel.Read(response, 1);
            CheckInput(result);
            _progId = response[0];

            return (byte)_progId;
        }
    }

    public short GetProgVer()
    {
        lock (Channel)
        {
            if (_progVer != null)
                return (short)_progVer;

            byte[] buf = new byte[5];
            if (FourC(0x10, buf, buf.Length, true) != 2)
                new InvalidOperationException(nameof(GetProgVer));
            _progVer = BitUtils.UnpackShort(buf, false);

            return (short)_progVer;
        }
    }

    public int GetSerNum()
    {
        lock (Channel)
        {
            if (_sernum != null)
                return (int)_sernum;

            byte[] buf = new byte[7];
            if (FourC(0x20, buf, buf.Length, true) != 4)
                new InvalidOperationException(nameof(GetSerNum));
            _sernum = BitUtils.UnpackInt(buf);
            return (int)_sernum;
        }
    }

    public void RelayOn(int port, int interval, bool suppressDoorEvent)
    {
        if (port < 1 || port > 8)
            throw new ArgumentOutOfRangeException(nameof(port), "Port must be between 1 and 8");
        if (interval < 0 || interval > 31)
            throw new ArgumentOutOfRangeException(nameof(interval), "Interval must be between 0 and 31");

        lock (Channel)
        {
            if (_progVer >= 33)
            {
                var cmd = new Command(this, 0x11, 3, 2);
                cmd[0] = Address;
                cmd[1] = suppressDoorEvent ? (byte)((port - 1) | 192) : (byte)((port - 1) | 64);
                cmd[2] = (byte)(interval * 4);
                cmd.Execute();
            }
            else
            {
                byte[] cmd = new byte[] { 0x16, suppressDoorEvent ? (byte)0x6A : (byte)0x69, Address, (byte)((interval << 3) | (port - 1)) };
                Channel.Write(cmd);
                Channel.Write(cmd); // Send twice
            }
        }
    }

    public void RelayOff(int port)
    {
        if (port < 1 || port > 8)
            throw new ArgumentOutOfRangeException(nameof(port), "Port must be between 1 and 8");

        lock (Channel)
        {
            if (_progVer >= 33)
            {
                var cmd = new Command(this, 0x10, 2, 1);
                cmd[0] = Address;
                cmd[1] = (byte)(1 << (port - 1));
                cmd.Execute();
            }
            else
            {
                byte[] cmd = new byte[] { 0x16, 0x6B, Address, (byte)(1 << (port - 1)) };
                Channel.Write(cmd);
                Channel.Write(cmd); // Send twice
            }
        }
    }

     public void PollOn(bool isAuto, bool isReliable)
    {
        lock (Channel)
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
        lock (Channel)
        {
            _polling = false;
            _deadTimer.Change(Timeout.Infinite, Timeout.Infinite);
            _aliveTimer.Change(Timeout.Infinite, Timeout.Infinite);
            _recoverState = RecoverNone;

            if (forceAuto && Channel.IsReady)
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

    // public void EventsInfo(out int capacity, out int count)
    // {
    //     lock (Channel)
    //     {
    //         if (_progVer == 0)
    //         {
    //             EventsInfo201(out capacity, out count);
    //         }
    //         else
    //         {
    //             EventsInfoNormal(out capacity, out count);
    //         }
    //     }
    // }

    public void KeysInfo(out int capacity, out int count)
    {
        lock (Channel)
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
        lock (Channel)
        {
            if (_progVer < 11)
            {
                throw new SpotException(this, "Feature", "Unsupported feature");
            }

            byte[] buf = new byte[4];
            int respLen = Execute4C(0x40, buf, false);
            if (respLen != 1)
            {
                throw new SpotException(this, "Protocol", "Unexpected response");
            }
            ExpandMask(ports, buf[2]);
        }
    }
}
