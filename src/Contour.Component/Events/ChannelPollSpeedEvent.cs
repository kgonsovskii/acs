namespace SevenSeals.Tss.Contour.Events;

public class ChannelPollSpeedEvent : ChannelEvent
{
    public int Value { get; }

    public ChannelPollSpeedEvent(string channelId, int value)
        : base(EventType.ChannelPollSpeed, channelId)
    {
        Value = value;
    }
}
