namespace SevenSeals.Tss.Contour.Events;

public class ChannelStateSendableEvent : ChannelSendableEvent
{
    public ChannelStateSendableEvent(ChannelStateEvent evt) : base("ChannelState", evt)
    {
        Parameters["ISREADY"] = evt.IsReady;
    }
}
