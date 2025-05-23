namespace SevenSeals.Tss.Contour.Events;

public class ControllerPortButtonSendableEvent : ControllerPortSendableEvent
{
    public ControllerPortButtonSendableEvent(ControllerEvent evt) : base("ControllerButton", evt)
    {
        Data[18] = (byte)((evt.GetData()[1] & 15) == 5 ? 1 : 0); // isOpen
        Parameters["DATA"] = Data;
    }
}
