namespace SevenSeals.Tss.Contour.Events;

public class ControllerTimerSendableEvent : ControllerSendableEvent
{
    public ControllerTimerSendableEvent(ControllerEvent evt) : base("ControllerTimer", evt)
    {
        Parameters["DATA"] = Data;
    }
}
