using System.Text;

namespace SevenSeals.Tss.Contour;

public static class BitUtils
{
    public static void ExpandMask<TOut>(TOut[] output, uint mask) where TOut : struct
    {
        var bitCount = sizeof(uint) * 8;
        for (var i = 0; i < bitCount; i++)
        {
            output[i] = (TOut)Convert.ChangeType((mask & (1u << i)) != 0, typeof(TOut));
        }
    }

    public static string HexDump(byte[] buf, int size)
    {
        var sb = new StringBuilder(size * 3);
        for (var i = 0; i < size; i++)
        {
            sb.AppendFormat("{0:X2} ", buf[i]);
        }

        if (sb.Length > 0)
            sb.Length -= 1; // remove trailing space

        return sb.ToString();
    }

    public static byte BcdToBin(byte val)
    {
        return (byte)((val & 0x0F) + 10 * ((val & 0xF0) >> 4));
    }

    public static byte BinToBcd(byte val)
    {
        var x = (byte)(val / 10);
        return (byte)((x << 4) + (val - x * 10));
    }

    public static byte[] PackShort(ushort x, bool isBigEndian = false)
    {
        var buf = new byte[2];
        if (isBigEndian)
        {
            buf[0] = (byte)(x >> 8);
            buf[1] = (byte)x;
        }
        else
        {
            buf[0] = (byte)x;
            buf[1] = (byte)(x >> 8);
        }
        return buf;
    }

    public static short UnpackShort(byte[] buf, bool isBigEndian = false)
    {
        return (short)(isBigEndian
            ? (buf[1] | (buf[0] << 8))
            : ((buf[1] << 8) | buf[0]));
    }

    public static byte[] PackInt(uint x)
    {
        return new byte[]
        {
            (byte)x,
            (byte)(x >> 8),
            (byte)(x >> 16),
            (byte)(x >> 24)
        };
    }

    public static int UnpackInt(byte[] buf)
    {
        return (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
    }
}

