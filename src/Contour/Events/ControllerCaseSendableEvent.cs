namespace SevenSeals.Tss.Contour.Events;

public class ControllerCaseSendableEvent : ControllerSendableEvent
{
    public ControllerCaseSendableEvent(ControllerEvent evt) : base("ControllerCase", evt)
    {
        Parameters["DATA"] = Data;
    }
}
