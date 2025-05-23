namespace SevenSeals.Tss.Contour.Events;

public class WriteAllKeysAsyncSendableEvent : ChannelSendableEvent
{
    public WriteAllKeysAsyncSendableEvent(WriteAllKeysAsyncEvent evt) : base("WriteAllKeysAsync", evt)
    {
        Parameters["ADDR"] = evt.Address;
        Parameters["ERROR"] = evt.Error;
    }
}
