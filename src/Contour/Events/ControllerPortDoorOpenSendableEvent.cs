namespace SevenSeals.Tss.Contour.Events;

public class ControllerPortDoorOpenSendableEvent : ControllerPortSendableEvent
{
    public ControllerPortDoorOpenSendableEvent(ControllerEvent evt) : base("ControllerDoorOpen", evt)
    {
        Parameters["DATA"] = Data;
    }
}
