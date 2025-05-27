namespace SevenSeals.Tss.Contour.Events;



public class ChannelErrorSendableEvent : ChannelSendableEvent
{
    public ChannelErrorSendableEvent(string name, ChannelErrorEvent evt) : base(name, evt)
    {
        Parameters["CLASS"] = evt.ErrorClass;
        Parameters["MESSAGE"] = evt.Message;
    }
}
