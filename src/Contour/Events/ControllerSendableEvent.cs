namespace SevenSeals.Tss.Contour.Events;


public class ControllerSendableEvent : SendableEvent
{
    protected readonly byte[] Data = new byte[30];

    public ControllerSendableEvent(string name, ControllerEvent evt) : base(name)
    {
      /*  Parameters["CHANNEL"] = evt.ChannelId;
        Array.Copy(evt.ControllerTimestamp.ToBinary(), 0, Data, 0, 8);
        Data[6] = evt.Address;
        BitConverter.GetBytes(evt.No).CopyTo(Data, 7);
        Data[9] = (byte)(evt.IsAuto ? 1 : 0);
        Array.Copy(evt.ControllerTimestamp.ToBinary(), 0, Data, 10, 8);
        Data[16] = (byte)(evt.IsLast ? 1 : 0);*/
    }

    public override Task ExecuteAsync(Client client, bool noAck)
    {
        // Implementation for controller event execution
        return Task.CompletedTask;
    }
}
