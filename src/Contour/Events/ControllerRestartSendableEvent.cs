namespace SevenSeals.Tss.Contour.Events;

public class ControllerRestartSendableEvent : ControllerSendableEvent
{
    public ControllerRestartSendableEvent(ControllerEvent evt) : base("ControllerRestart", evt)
    {
        Parameters["DATA"] = Data;
    }
}
