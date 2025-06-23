namespace SevenSeals.Tss.Contour.Events;

public enum EventType
{
    None,
    Controller,
    ChannelError,
    ControllerError,
    ChannelState,
    ChannelPollSpeed,
    ControllerState,
    ChannelsChanged,
    ControllersChanged,
    ClientsChanged,
    QueueFull,
    WriteAllKeysAsync
}
