namespace SevenSeals.Tss.Contour.Events;

public class ControllerPortSendableEvent : ControllerSendableEvent
{
    public ControllerPortSendableEvent(string name, ControllerEvent evt) : base(name, evt)
    {
        Data[17] = (byte)(((evt.Data[1] >> 4) & 7) + 1); // Port
    }
}
