namespace SevenSeals.Tss.Contour.Events;

public class ControllerPortKeySendableEvent : ControllerPortSendableEvent
{
    public ControllerPortKeySendableEvent(ControllerEvent evt) : base("ControllerKey", evt)
    {
        // Implementation for key event data
        Parameters["DATA"] = Data;
    }
}

