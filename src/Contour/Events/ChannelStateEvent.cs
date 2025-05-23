namespace SevenSeals.Tss.Contour.Events;

public class ChannelStateEvent : ChannelEvent
{
    public bool IsReady { get; }

    public ChannelStateEvent(string channelId, bool isReady)
        : base(EventType.ChannelState, channelId)
    {
        IsReady = isReady;
    }
}
