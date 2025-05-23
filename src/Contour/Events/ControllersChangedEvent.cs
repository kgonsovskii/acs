namespace SevenSeals.Tss.Contour.Events;



public class ControllersChangedEvent : ChannelEvent
{
    public ControllersChangedEvent(string channelId)
        : base(EventType.ControllersChanged, channelId)
    {
    }
}
