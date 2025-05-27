namespace SevenSeals.Tss.Contour.Events;

public class ControllerErrorEvent : ChannelErrorEvent
{
    public byte ControllerAddress { get; }

    public ControllerErrorEvent(string channelId, string errorClass, string message, byte controllerAddress)
        : base(EventType.ControllerError, channelId, errorClass, message)
    {
        ControllerAddress = controllerAddress;
    }
}
