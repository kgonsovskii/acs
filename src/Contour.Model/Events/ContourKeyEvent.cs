namespace SevenSeals.Tss.Contour.Events;

public class ContourKeyEvent : ContourEvent
{
    public ContourKeyEvent(string channelId, byte[] evt) : base(channelId, evt)
    {
        Kind = KindEnum.Key;
    }

    // Parameterless constructor for JSON deserialization
    public ContourKeyEvent() : base("", new byte[16])
    {
        Kind = KindEnum.Key;
    }

    public string KeyNumber
    {
        get
        {
            // Extract the original key data from the event (before reversal)
            var originalKey = new byte[6];
            Array.Copy(Data, 2, originalKey, 0, 6);

            // Apply the same reversal as the C++ reverseCopyKey method
            var reversedKey = new byte[6];
            reversedKey[0] = originalKey[5];  // Last byte becomes first
            reversedKey[1] = originalKey[4];  // Second-to-last becomes second
            reversedKey[2] = originalKey[3];  // Middle bytes swap
            reversedKey[3] = originalKey[2];
            reversedKey[4] = originalKey[1];  // Second becomes second-to-last
            reversedKey[5] = originalKey[0];  // First byte becomes last

            // Convert to hex string using the existing KeyToStr method
            return KeyToStr(reversedKey);
        }
    }

    private static string KeyToStr(byte[] key)
    {
        return string.Join("", key.Take(6).Select(b => b.ToString("X2")));
    }

    private static byte[] ReverseCopyKey(byte[] output, byte[] key)
    {
        output[0] = key[5];
        output[1] = key[4];
        output[2] = key[3];
        output[3] = key[2];
        output[4] = key[1];
        output[5] = key[0];
        return output;
    }

    public override int ProtoSize => 30;

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

        // Key-specific data initialization
        // Port calculation from C++: (evt.data()[1] >> 4 & 7) + 1
        protoData[17] = (byte)(((Data[1] >> 4) & 7) + 1);

        // Copy key data using ReverseCopyKey (from C++: servcont::Controller::reverseCopyKey(&data[19], &evt.data()[2]))
        var keyData = new byte[6];
        Array.Copy(Data, 2, keyData, 0, 6); // Extract key data from base.Data[2] onwards
        var reversedKey = new byte[6];
        ReverseCopyKey(reversedKey, keyData); // Use existing ReverseCopyKey implementation
        Array.Copy(reversedKey, 0, protoData, 19, 6); // Copy reversed key to protoData[19] onwards

        if (IsAuto)
        {
            // isOpen: (base.Data[1] & 15) == 7
            protoData[18] = (byte)((Data[1] & 15) == 7 ? 1 : 0);

            // IsTimeRestrict: (base.Data[12] & 31) == 16 - допуск по временным ограничениям есть
            protoData[25] = (byte)((Data[12] & 31) == 16 ? 1 : 0);

            // IsTimeRestrictDone: !((base.Data[12] & 15) == 8) - была попытка применить временные ограничения
            protoData[26] = (byte)((Data[12] & 15) == 8 ? 0 : 1);

            // IsAccessGranted: !((base.Data[12] & 7) == 4) - доступ по этому каналу разрешен
            protoData[27] = (byte)((Data[12] & 7) == 4 ? 0 : 1);

            // IsKeyFound: !((base.Data[12] & 3) == 2) - ключ в БК найден
            protoData[28] = (byte)((Data[12] & 3) == 2 ? 0 : 1);

            // IsKeySearchDone: !(base.Data[12] & 1) - был произведен поиск в базе ключей
            protoData[29] = (byte)((Data[12] & 1) == 0 ? 1 : 0);
        }

        return protoData;
    }
}
