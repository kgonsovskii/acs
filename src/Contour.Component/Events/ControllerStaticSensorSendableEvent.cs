namespace SevenSeals.Tss.Contour.Events;

public class ControllerStaticSensorSendableEvent : ControllerSendableEvent
{
    public ControllerStaticSensorSendableEvent(ControllerEvent evt) : base("ControllerStaticSensor", evt)
    {
        Data[17] = evt.Data[3];
        Parameters["DATA"] = Data;
    }
}

