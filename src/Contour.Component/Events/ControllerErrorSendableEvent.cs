namespace SevenSeals.Tss.Contour.Events;


public class ControllerErrorSendableEvent : ChannelErrorSendableEvent
{
    public ControllerErrorSendableEvent(ControllerErrorEvent evt) : base("ControllerError", evt)
    {
        Parameters["ADDR"] = evt.ControllerAddress;
    }
}
