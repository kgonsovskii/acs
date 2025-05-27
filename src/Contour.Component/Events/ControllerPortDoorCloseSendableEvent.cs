namespace SevenSeals.Tss.Contour.Events;

public class ControllerPortDoorCloseSendableEvent : ControllerPortSendableEvent
{
    public ControllerPortDoorCloseSendableEvent(ControllerEvent evt) : base("ControllerDoorClose", evt)
    {
        Parameters["DATA"] = Data;
    }
}
