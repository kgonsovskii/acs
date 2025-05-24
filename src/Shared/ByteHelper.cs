namespace SevenSeals.Tss.Shared;

public static class ByteHelper
{
    public static string ToTssString(this byte[] bytes)
    {
        return BitConverter.ToString(bytes).Replace("-", "");
    }
}
