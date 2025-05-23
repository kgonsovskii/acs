namespace SevenSeals.Tss.Contour.Events;


public class Controller220VSendableEvent : ControllerSendableEvent
{
    public Controller220VSendableEvent(ControllerEvent evt) : base("Controller220V", evt)
    {
        Parameters["DATA"] = Data;
    }
}
