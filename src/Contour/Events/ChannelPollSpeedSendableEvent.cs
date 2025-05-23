namespace SevenSeals.Tss.Contour.Events;

public class ChannelPollSpeedSendableEvent : ChannelSendableEvent
{
    public ChannelPollSpeedSendableEvent(ChannelPollSpeedEvent evt) : base("ChannelPollSpeed", evt)
    {
        Parameters["VALUE"] = evt.Value;
    }
}

