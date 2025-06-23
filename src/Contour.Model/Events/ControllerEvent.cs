using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Events;

public abstract class ControllerEvent : ChannelEvent, IProtoEvent
{
    public enum KindEnum
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

    public KindEnum Kind { get; set; }

    public virtual string? Channel => null;
    public virtual DateTime? Time => null;

    public virtual bool? IsReady => null;
    public virtual int? Value => null;
    public virtual byte? State => null;

    public bool Used { get; set; }

    public virtual byte Address => 0;

    public byte[] Data => _data;

    public virtual int ProtoSize => Size;

    public virtual byte[] ToProtoData()
    {
        // Default implementation returns the base data
        var protoData = new byte[ProtoSize];
        Array.Copy(_data, 0, protoData, 0, Math.Min(Size, ProtoSize));
        return protoData;
    }

    public static ControllerEvent Create(string channelId, byte[] evt)
    {
        var kind = GetKindFromData(evt);
        return kind switch
        {
            KindEnum.Key => new ControllerKeyEvent(channelId, evt),
            KindEnum.Button => new ControllerButtonEvent(channelId, evt),
            KindEnum.DoorOpen => new ControllerDoorOpenEvent(channelId, evt),
            KindEnum.DoorClose => new ControllerDoorCloseEvent(channelId, evt),
            KindEnum.Power220V => new ControllerPower220VEvent(channelId, evt),
            KindEnum.Case => new ControllerCaseEvent(channelId, evt),
            KindEnum.Timer => new ControllerTimerEvent(channelId, evt),
            KindEnum.AutoTimeout => new ControllerAutoTimeoutEvent(channelId, evt),
            KindEnum.Restart => new ControllerRestartEvent(channelId, evt),
            KindEnum.Start => new ControllerStartEvent(channelId, evt),
            KindEnum.StaticSensor => new ControllerStaticSensorEvent(channelId, evt),
            _ => new ControllerUnknownEvent(channelId, evt)
        };
    }

    private static KindEnum GetKindFromData(byte[] evt)
    {
        var x = (byte)(evt[1] & 7);
        if (x == 6 || x == 7)
            return KindEnum.Key;
        if (x == 4 || x == 5)
            return KindEnum.Button;
        if ((evt[1] & 15) == 3)
            return KindEnum.DoorOpen;
        if ((evt[1] & 15) == 11)
            return KindEnum.DoorClose;
        if (x == 1)
        {
            switch ((evt[1] >> 4) & 7)
            {
                case 0: return KindEnum.Power220V;
                case 1: return KindEnum.Case;
                case 2: return KindEnum.Timer;
                case 3: return KindEnum.AutoTimeout;
                case 6: return KindEnum.Restart;
                case 7: return KindEnum.Start;
                default: return KindEnum.None;
            }
        }

        if (x == 2)
            return KindEnum.StaticSensor;
        return KindEnum.None;
    }

    protected ControllerEvent(string channelId, byte[] evt)
        : base(EventType.Controller, channelId)
    {
        _data = new byte[Size];
        Array.Copy(evt, _data, Size);
        InitializeControllerTimestamp();
        Kind = GetKind();
    }

    protected ControllerEvent(string channelId, byte[] evt, DateTime timestamp)
        : base(EventType.Controller, channelId)
    {
        _data = new byte[Size];
        Array.Copy(evt, _data, Size);
        InitializeControllerTimestamp();
    }

    public KindEnum GetKind()
    {
        var x = (byte)(_data[1] & 7);
        if (x == 6 || x == 7)
            return KindEnum.Key;
        if (x == 4 || x == 5)
            return KindEnum.Button;
        if ((_data[1] & 15) == 3)
            return KindEnum.DoorOpen;
        if ((_data[1] & 15) == 11)
            return KindEnum.DoorClose;
        if (x == 1)
        {
            switch ((_data[1] >> 4) & 7)
            {
                case 0: return KindEnum.Power220V;
                case 1: return KindEnum.Case;
                case 2: return KindEnum.Timer;
                case 3: return KindEnum.AutoTimeout;
                case 6: return KindEnum.Restart;
                case 7: return KindEnum.Start;
                default: return KindEnum.None;
            }
        }

        if (x == 2)
            return KindEnum.StaticSensor;
        return KindEnum.None;
    }

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
            var x = (ushort)(_data[11] << 8 | _data[10]);
            var year = ((x >> 9) & 63) + 2000;
            var month = (x >> 5) & 15;
            var day = x & 31;

            System.Diagnostics.Debug.WriteLine(
                $"Timestamp parsing - Raw: 0x{_data[10]:X2} 0x{_data[11]:X2}, x: 0x{x:X4}, year: {year}, month: {month}, day: {day}");

            if (month < 1 || month > 12) month = 1;
            if (day < 1 || day > 31) day = 1;
            if (year < 2000 || year > 2099) year = 2000;

            _controllerTimestamp = new DateTime(
                year,
                month,
                day,
                BcdToBin(_data[15]),
                BcdToBin(_data[14]),
                BcdToBin(_data[13])
            );
        }
        else
        {
            var year = 0;
            int month, day;

            if (HasDate)
            {
                month = BcdToBin(_data[11]);
                day = BcdToBin(_data[10]);
            }
            else
            {
                month = 1;
                day = 1;
            }

            if (month < 1 || month > 12) month = 1;
            if (day < 1 || day > 31) day = 1;

            _controllerTimestamp = new DateTime(
                year,
                month,
                day,
                BcdToBin(_data[15]),
                BcdToBin(_data[14]),
                BcdToBin(_data[13])
            );
        }
    }

    private static int BcdToBin(byte bcd)
    {
        return ((bcd >> 4) * 10) + (bcd & 0x0F);
    }
}
