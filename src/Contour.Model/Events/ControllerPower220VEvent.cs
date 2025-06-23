namespace SevenSeals.Tss.Contour.Events;

public class ControllerPower220VEvent : ControllerEvent
{
    public ControllerPower220VEvent(string channelId, byte[] evt) : base(channelId, evt)
    {
        Kind = KindEnum.Power220V;
    }

    public ControllerPower220VEvent(string channelId, byte[] evt, DateTime timestamp) : base(channelId, evt, timestamp)
    {
        Kind = KindEnum.Power220V;
    }

    // Override ProtoSize for transmission
    public override int ProtoSize => 17;

    // Override ToProtoData to generate transmission data
    public override byte[] ToProtoData()
    {
        var protoData = new byte[ProtoSize];
        
        // Copy base data (first 6 bytes - timestamp)
        Array.Copy(Data, 0, protoData, 0, 6);
        
        protoData[6] = Address;
        
        // Pack No (2 bytes)
        var noBytes = BitConverter.GetBytes(No);
        Array.Copy(noBytes, 0, protoData, 7, 2);
        
        protoData[9] = (byte)(IsAuto ? 1 : 0);
        
        // Copy controller timestamp (first 6 bytes again, as in C++)
        Array.Copy(Data, 0, protoData, 10, 6);
        
        protoData[16] = (byte)(IsLast ? 1 : 0);
        
        return protoData;
    }
}
