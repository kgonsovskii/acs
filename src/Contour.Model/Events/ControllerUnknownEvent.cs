namespace SevenSeals.Tss.Contour.Events;

public class ControllerUnknownEvent : ControllerEvent
{
    public ControllerUnknownEvent(string channelId, byte[] evt) : base(channelId, evt)
    {
        Kind = KindEnum.None;
    }

    public ControllerUnknownEvent(string channelId, byte[] evt, DateTime timestamp) : base(channelId, evt, timestamp)
    {
        Kind = KindEnum.None;
    }
} 