namespace SevenSeals.Tss.Contour.Events;


public class ControllerStateEvent : ChannelEvent
{
    public byte ControllerAddress { get; }
    public byte State { get; }

    public ControllerStateEvent(string channelId, byte controllerAddress, byte state)
        : base(EventType.ControllerState, channelId)
    {
        ControllerAddress = controllerAddress;
        State = state;
    }
}
