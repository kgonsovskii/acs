namespace SevenSeals.Tss.Contour.Events;

public class ChannelErrorEvent : ChannelEvent
{
    public ChannelErrorEvent(string channelId, string errorClass, string message) : base(EventType.ChannelError, channelId)
    {
        ErrorClass = errorClass;
        Message = message;
    }
}
