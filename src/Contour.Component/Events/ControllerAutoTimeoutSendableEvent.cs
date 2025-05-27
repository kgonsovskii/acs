namespace SevenSeals.Tss.Contour.Events;

public class ControllerAutoTimeoutSendableEvent : ControllerSendableEvent
{
    public ControllerAutoTimeoutSendableEvent(ControllerEvent evt) : base("ControllerAutoTimeout", evt)
    {
        Parameters["DATA"] = Data;
    }
}
