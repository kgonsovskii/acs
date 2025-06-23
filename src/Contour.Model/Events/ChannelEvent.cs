namespace SevenSeals.Tss.Contour.Events;

public abstract class ChannelEvent : Event
{
    public string ChannelId { get; }

    protected ChannelEvent(EventType type, string channelId)
    {
        Type = type;
        ChannelId = channelId;
    }

    public virtual string? Error => null;
    public virtual string? ErrorClass { get; set; }
    public virtual string? Message { get; set; }
}
