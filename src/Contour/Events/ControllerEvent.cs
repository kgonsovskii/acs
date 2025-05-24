using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Events;

public class ControllerEvent : ChannelEvent
{
    public enum Kind
    {
        None,
        Key,
        Button,
        DoorOpen,
        DoorClose,
        Power220V,
        Case,
        Timer,
        AutoTimeout,
        Restart,
        Start,
        StaticSensor
    }

    public const int Size = 16;

    private readonly byte[] _data;

    private DateTime _controllerTimestamp;

    public bool Used { get; set; }

    public ControllerEvent(string channelId, byte[] evt)
        : base(EventType.Controller, channelId)
    {
        _data = new byte[Size];
        Array.Copy(evt, _data, Size);
        InitializeControllerTimestamp();
    }

    public ControllerEvent(string channelId, byte[] evt, DateTime timestamp)
        : base(EventType.Controller, channelId)
    {
        _data = new byte[Size];
        Array.Copy(evt, _data, Size);
        InitializeControllerTimestamp();
    }

    public ControllerEvent(byte[] channelId, byte[] evt, byte[] timestamp)
        : base(EventType.Controller, channelId.ToTssString())
    {
        _data = new byte[Size];
        Array.Copy(evt, _data, Size);
        InitializeControllerTimestamp();
    }

    public Kind GetKind()
    {
        byte x = (byte)(_data[1] & 7);
        if (x == 6 || x == 7)
            return Kind.Key;
        if (x == 4 || x == 5)
            return Kind.Button;
        if ((_data[1] & 15) == 3)
            return Kind.DoorOpen;
        if ((_data[1] & 15) == 11)
            return Kind.DoorClose;
        if (x == 1)
        {
            switch ((_data[1] >> 4) & 7)
            {
                case 0: return Kind.Power220V;
                case 1: return Kind.Case;
                case 2: return Kind.Timer;
                case 3: return Kind.AutoTimeout;
                case 6: return Kind.Restart;
                case 7: return Kind.Start;
                default: return Kind.None;
            }
        }

        if (x == 2)
            return Kind.StaticSensor;
        return Kind.None;
    }

    public byte[] Data => _data;
    public byte Address => _data[0];
    public ushort No => (ushort)((_data[9] << 8) | _data[8]);
    public bool IsAuto => (_data[12] & 128) != 0;
    public bool IsLast => (_data[1] & 128) == 0;
    public bool HasYear => (_data[11] & 128) != 0;
    public bool HasDate => _data[10] != 0 || _data[11] != 0;
    public DateTime ControllerTimestamp => _controllerTimestamp;

    private void InitializeControllerTimestamp()
    {
        if (HasYear)
        {
            ushort x = (ushort)((_data[10] << 8) | _data[11]);
            _controllerTimestamp = new DateTime(
                ((x >> 9) & 63) + 2000,
                (x >> 5) & 15,
                x & 31,
                BcdToBin(_data[15]),
                BcdToBin(_data[14]),
                BcdToBin(_data[13])
            );
        }
        else
        {
            _controllerTimestamp = new DateTime(
                    HasDate ? BcdToBin(_data[11]) : 1,
                    HasDate ? BcdToBin(_data[10]) : 1,
                    BcdToBin(_data[15]),
                    BcdToBin(_data[14]),
                    BcdToBin(_data[13]),
                    0);
        }
    }

    private static int BcdToBin(byte bcd)
    {
        return ((bcd >> 4) * 10) + (bcd & 0x0F);
    }
}
