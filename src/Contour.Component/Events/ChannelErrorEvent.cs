namespace SevenSeals.Tss.Contour.Events;

public class ChannelErrorEvent : ChannelEvent
{
    public string ErrorClass { get; }
    public string Message { get; }

    public ChannelErrorEvent(EventType type, string channelId, string errorClass, string message)
        : base(type, channelId)
    {
        ErrorClass = errorClass;
        Message = message;
    }

    public ChannelErrorEvent(string channelId, string errorClass, string message)
        : this(EventType.ChannelError, channelId, errorClass, message)
    {
    }
}
