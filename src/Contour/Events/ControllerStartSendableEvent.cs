namespace SevenSeals.Tss.Contour.Events;

public class ControllerStartSendableEvent : ControllerSendableEvent
{
    public ControllerStartSendableEvent(ControllerEvent evt) : base("ControllerStart", evt)
    {
        Parameters["DATA"] = Data;
    }
}
