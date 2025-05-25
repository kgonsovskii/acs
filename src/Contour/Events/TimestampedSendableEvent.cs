namespace SevenSeals.Tss.Contour.Events;


public class TimestampedSendableEvent : SendableEvent
{
    public TimestampedSendableEvent(string name, Event evt) : base(name)
    {
        Parameters["TIME"] = evt.Timestamp;
    }

    public override Task ExecuteAsync(Client client, bool noAck)
    {
        throw new NotImplementedException();
    }
}
