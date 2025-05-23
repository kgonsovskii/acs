namespace SevenSeals.Tss.Contour.Events;





public class ChannelEvent : Event
{
    public string ChannelId { get; }

    protected ChannelEvent(EventType type, string channelId)
    {
        Type = type;
        ChannelId = channelId;
    }

    public override EventType Type { get; }
}

