namespace SevenSeals.Tss.Contour.Events;



public class WriteAllKeysAsyncEvent : ChannelEvent
{
    public byte Address { get; }
    public string Error { get; }

    public WriteAllKeysAsyncEvent(string channelId, byte address, string error)
        : base(EventType.WriteAllKeysAsync, channelId)
    {
        Address = address;
        Error = error;
    }
}
