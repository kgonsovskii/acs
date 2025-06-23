namespace SevenSeals.Tss.Contour.Events;

public class ContourButtonEvent : ContourEvent
{
    public ContourButtonEvent(string channelId, byte[] evt) : base(channelId, evt)
    {
        Kind = KindEnum.Button;
    }

    // Parameterless constructor for JSON deserialization
    public ContourButtonEvent() : base("", new byte[16])
    {
        Kind = KindEnum.Button;
    }

    public override int ProtoSize => 19;

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

        // Button-specific data initialization
        // Port calculation from C++: (evt.data()[1] >> 4 & 7) + 1
        protoData[17] = (byte)(((Data[1] >> 4) & 7) + 1);

        // isOpen: (base.Data[1] & 15) == 5
        protoData[18] = (byte)((Data[1] & 15) == 5 ? 1 : 0);

        return protoData;
    }
} 