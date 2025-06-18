namespace SevenSeals.Tss.Contour;

public partial class Contour
{
    private enum MemType
    {
        None,
        Ram,
        Eeprom
    }

    private enum MemOp
    {
        None,
        Off,
        Read,
        Write
    }

    private int FourC(byte op, byte[] buf, int size, bool checkOp)
    {
        buf[0] = 0x16;
        buf[1] = 0x6C;
        buf[2] = Address;
        buf[3] = op;
        Channel.Write(buf, 4);
        return ReadPack(buf, size, checkOp);
    }

    void ReadEvt()
    {
        var cmd = new byte[] { 0x16, _autonomic ? (byte)0x3B : (byte)0x2B, Address };
        var buf = new byte[17];
        Channel.Write(cmd, cmd.Length);
       // Channel._lastEvtCo = addr;
        var read = 0;
        var isEvent = false;

        while (true)
        {
            var r = Channel.Read(buf, read, buf.Length - read);
            CheckInput(r);
            read += r;

            if (read == buf.Length)
            {
                _processEvt(buf);
                isEvent = true;
                break;
            }

            if (read == 3 && buf[0] == Address && buf[1] == 0)
            {
                if (buf[2] == Address)
                    break; // No events
                if (buf[2] == (byte)~Address)
                    break; // Busy (silent)
            }
            else if (read == 4 && buf[1] == Address && buf[2] == 0 && buf[3] == Address)
            {
                break; // No events (special firmware case)
            }
        }

       // Channel._lastEvtCo = 0;
      //  ++Channel._speedCounter;

        if (!isEvent)
        {
            //_setState(_autonomic ? _stateAutonomicPolling : _stateComplex);
        }

        void _processEvt(byte[] buf)
        {
            if (buf[16] != Cs8(buf, 16))
                throw new SpotException(this, "Error", "CheckSum Error");

            if (buf[0] != Address)
                throw new SpotException(this, "Error", "Unexpected response");

            if ((buf[12] & 0x40) != 0 && ProgId == 0x9C)
                throw new SpotException(this, "Error", "Erroneous event");

            //  _setState(_autonomic ? _stateAutonomicPolling : _stateComplex);

            OnEvent?.Invoke(this, buf);
        }
    }


    private void ReadEvt2(bool isAuto)
    {
        var cmd = new byte[] { 0x16, isAuto ? (byte)0x3A : (byte)0x2A, Address };
        var buf = new byte[17];
        Channel.Write(cmd);
        var read = 0;

        while (true)
        {
            var r = Channel.Read(buf, read, buf.Length - read);
            if (r == 0)
                break;

            read += r;
            if (read == buf.Length)
                break;
            if (read == 3 && buf[0] == Address && buf[1] == 0)
            {
                if (buf[2] == Address) // No events?
                    break;
                if (buf[2] == (byte)~Address) // Busy?
                    break;
            }
            else if (read == 4 && buf[1] == Address && buf[2] == 0 && buf[3] == Address)
                break;
        }
    }

    private void EventsInfo201(out int capacity, out int count)
    {
        capacity = ReadRpd(0x53) + ReadRpd(0x54) * 256;
        count = ReadRpd(0x34) + ReadRpd(0x35) * 256;
    }

    private void EventsInfoNormal(out int capacity, out int count)
    {
        var buf = new byte[10];
        var respLen = Execute4C(1, buf, true);
        if (!((buf[2] == 2 && respLen == 5) || (buf[2] == 3 && respLen == 7)))
        {
            throw new SpotException(this, "Protocol", "Unexpected response");
        }

        //capacity = VarVal(buf, 2, 1);
        //count = VarVal(buf, 2, 1 + buf[2]);
        capacity = 0;
        count = 0;
    }

    private void KeysInfo201(out int capacity, out int count)
    {
        var offBeg = ReadRpd(0x4E) * 256;
        short pageCount = ReadRpd(0x4F);
        capacity = pageCount * 31;
        var buf = new byte[6 + 8];
        count = 0;

        for (short pageIdx = 0; pageIdx != pageCount; ++pageIdx)
        {
            ReadMem(offBeg + (pageIdx * 256), buf, 0, buf.Length);
            if (IsDallas(buf, 5))
            {
                count += buf[12];
            }
            else
            {
                break;
            }
        }
    }

    private void KeysInfoNormal(out int capacity, out int count)
    {
        var kbi = new KBInfo(this);
        capacity = kbi.Capacity;
        count = kbi.Count;
    }

    private byte ReadRpd(byte offset)
    {
        var cmd = new byte[] { 0x16, 0x63, Address, offset };
        Channel.Write(cmd);
        byte ret;
        var r = Channel.Read(out ret);
        CheckInput(r);
        return ret;
    }

    private int VarVal(byte[] data, int idx)
    {
        int ret;
        switch (data[0])
        {
            case 2:
                ret = data[idx] | (data[1 + idx] << 8);
                break;
            case 3:
                ret = data[idx] | (data[1 + idx] << 8) | (data[2 + idx] << 16);
                break;
            default:
                throw new InvalidOperationException(nameof(VarVal));
        }
        return ret;
    }

    private bool IsDallas(byte[] buf, int offset)
    {
        return buf[offset] == 'D' && buf[offset + 1] == 'A' && buf[offset + 2] == 'L' &&
               buf[offset + 3] == 'L' && buf[offset + 4] == 'A' && buf[offset + 5] == 'S';
    }

    private void ReadMem(int offset, byte[] buf, int bufOffset, int count)
    {
        // Implement memory reading logic
    }

    private int Execute4C(byte op, byte[] buf, bool checkOp)
    {
        buf[0] = 0x16;
        buf[1] = 0x6C;
        buf[2] = Address;
        buf[3] = op;
        Channel.Write(buf, 0, 4);
        return ReadPack(buf, buf.Length, checkOp);
    }

    private int ReadPack(byte[] buf, int size, bool checkOp)
    {
        int read = 0, len = 0;
        while (true)
        {
            var r = Channel.Read(buf, read, size - read);
            if (r == 0)
                throw new SpotException(this, "Timeout", $"No response in {Channel.Options.ResponseTimeout} msec");

            read += r;
            if (len == 0)
                len = CheckPack(buf, read, checkOp);

            if (len != 0 && (read - 3) >= len)
                return len;

            if (size == read)
                throw new SpotException(this, "Protocol", "Unexpected response");
        }
    }

    private int CheckPack(byte[] buf, int size, bool checkOp)
    {
        var len = 0;

        if (size > 3)
        {
            if (buf[0] != Address)
                throw new SpotException(this, "Protocol", "Unexpected response");

            len = buf[1] - 1; // packLength
            if ((size - 3) >= len)
            {
                var x = len + 2;
                if (Cs8(buf, x) != buf[x])
                    throw new SpotException(this, "Error", "Invalid checksum");

                if (checkOp && len == 1)
                {
                    switch (buf[2])
                    {
                        case 0xFE:
                            throw new SpotException(this, "Error", "Invalid pack length");
                        case 0xFF:
                            throw new SpotException(this, "Error", "Illegal operation");
                    }
                }
            }
        }
        else if (size > 2 && buf[0] == Address && buf[1] == 0 && buf[2] == (byte)~Address)
        {
            throw new SpotException(this, "Error", "Busy");
        }
        else if (size > 1 && buf[0] == 0x16 && buf[1] == 0x15)
        {
            throw new SpotException(this, "Error", "Invalid checksum");
        }

        return len;
    }

    public static byte Cs8(byte[] buf, int size)
    {
        var ret = buf[0];
        for (var i = 1; i != size; ++i)
            ret += buf[i];
        return ret;
    }

    private static readonly byte[] Tbl =
    [
        0x00, 0x5E, 0xBC, 0xE2, 0x61, 0x3F, 0xDD, 0x83, 0xC2, 0x9C, 0x7E, 0x20, 0xA3, 0xFD, 0x1F, 0x41,
        0x9D, 0xC3, 0x21, 0x7F, 0xFC, 0xA2, 0x40, 0x1E, 0x5F, 0x01, 0xE3, 0xBD, 0x3E, 0x60, 0x82, 0xDC,
        0x23, 0x7D, 0x9F, 0xC1, 0x42, 0x1C, 0xFE, 0xA0, 0xE1, 0xBF, 0x5D, 0x03, 0x80, 0xDE, 0x3C, 0x62,
        0xBE, 0xE0, 0x02, 0x5C, 0xDF, 0x81, 0x63, 0x3D, 0x7C, 0x22, 0xC0, 0x9E, 0x1D, 0x43, 0xA1, 0xFF,
        0x46, 0x18, 0xFA, 0xA4, 0x27, 0x79, 0x9B, 0xC5, 0x84, 0xDA, 0x38, 0x66, 0xE5, 0xBB, 0x59, 0x07,
        0xDB, 0x85, 0x67, 0x39, 0xBA, 0xE4, 0x06, 0x58, 0x19, 0x47, 0xA5, 0xFB, 0x78, 0x26, 0xC4, 0x9A,
        0x65, 0x3B, 0xD9, 0x87, 0x04, 0x5A, 0xB8, 0xE6, 0xA7, 0xF9, 0x1B, 0x45, 0xC6, 0x98, 0x7A, 0x24,
        0xF8, 0xA6, 0x44, 0x1A, 0x99, 0xC7, 0x25, 0x7B, 0x3A, 0x64, 0x86, 0xD8, 0x5B, 0x05, 0xE7, 0xB9,
        0x8C, 0xD2, 0x30, 0x6E, 0xED, 0xB3, 0x51, 0x0F, 0x4E, 0x10, 0xF2, 0xAC, 0x2F, 0x71, 0x93, 0xCD,
        0x11, 0x4F, 0xAD, 0xF3, 0x70, 0x2E, 0xCC, 0x92, 0xD3, 0x8D, 0x6F, 0x31, 0xB2, 0xEC, 0x0E, 0x50,
        0xAF, 0xF1, 0x13, 0x4D, 0xCE, 0x90, 0x72, 0x2C, 0x6D, 0x33, 0xD1, 0x8F, 0x0C, 0x52, 0xB0, 0xEE,
        0x32, 0x6C, 0x8E, 0xD0, 0x53, 0x0D, 0xEF, 0xB1, 0xF0, 0xAE, 0x4C, 0x12, 0x91, 0xCF, 0x2D, 0x73,
        0xCA, 0x94, 0x76, 0x28, 0xAB, 0xF5, 0x17, 0x49, 0x08, 0x56, 0xB4, 0xEA, 0x69, 0x37, 0xD5, 0x8B,
        0x57, 0x09, 0xEB, 0xB5, 0x36, 0x68, 0x8A, 0xD4, 0x95, 0xCB, 0x29, 0x77, 0xF4, 0xAA, 0x48, 0x16,
        0xE9, 0xB7, 0x55, 0x0B, 0x88, 0xD6, 0x34, 0x6A, 0x2B, 0x75, 0x97, 0xC9, 0x4A, 0x14, 0xF6, 0xA8,
        0x74, 0x2A, 0xC8, 0x96, 0x15, 0x4B, 0xA9, 0xF7, 0xB6, 0xE8, 0x0A, 0x54, 0xD7, 0x89, 0x6B, 0x35
    ];

    public static byte Crc8(byte[] data, int size)
    {
        byte ret = 0;
        for (var i = 0; i != size; ++i)
            ret = Tbl[ret ^ data[i]];
        return ret;
    }

    public static bool IsKey(byte[] s)
    {
        return !(s[0] == 255 && s[1] == 255 && s[2] == 255 && s[3] == 255 && s[4] == 255 && s[5] == 255);
    }

    public static bool IsDallas(byte[] s)
    {
        return (s[0] == 'D' && s[1] == 'A' && s[2] == 'L' && s[3] == 'L' && s[4] == 'A' && s[5] == 'S');
    }

    public static bool IsAlarmX(byte[] s)
    {
        return (s[0] == 'A' && s[1] == 'L' && s[2] == 'A' && s[3] == 'R' && s[4] == 'M');
    }

    public static ulong KeyToInt(byte[] key)
    {
        return ((ulong)key[0] << 40) | ((ulong)key[1] << 32) | ((ulong)key[2] << 24) |
               ((ulong)key[3] << 16) | ((ulong)key[4] << 8) | key[5];
    }

    public static string KeyToStr(byte[] key)
    {
        return string.Join("", key.Take(6).Select(b => b.ToString("X2")));
    }

    public static void DecodeKeyAttr(byte[] key, out byte ports, out byte persCat,
        out bool suppressDoorEvent, out bool openEvenComplex, out bool isSilent)
    {
        ports = key[0];
        persCat = (byte)((key[1] & 15) + 1);
        suppressDoorEvent = ((key[1] & (1 << 5)) != 0);
        openEvenComplex = ((key[1] & (1 << 6)) != 0);
        isSilent = ((key[1] & (1 << 7)) != 0);
    }

    public static void UnpackKey(byte[] @out, byte[] key)
    {
        Array.Copy(key.Reverse().ToArray(), @out, 6);
        DecodeKeyAttr(key.Skip(6).ToArray(), out var ports, out var persCat,
            out var suppressDoorEvent, out var openEvenComplex, out var isSilent);
        ExpandMask(@out.Skip(6).ToArray(), ports);
        @out[14] = persCat;
        @out[15] = (byte)(suppressDoorEvent ? 1 : 0);
        @out[16] = (byte)(openEvenComplex ? 1 : 0);
        @out[17] = (byte)(isSilent ? 1 : 0);
    }

    public static void ExpandMask(byte[] @out, byte mask)
    {
        for (var i = 0; i < 8; i++)
        {
            @out[i] = (byte)((mask & (1 << i)) != 0 ? 1 : 0);
        }
    }

    public static byte ChipCheckCount(byte flags)
    {
        switch ((flags >> 3) & 7)
        {
            case 0: return 3;
            case 1: return 8;
            case 2: return 4;
            case 3: return 12;
            case 4: return 5;
            case 5: return 16;
            case 6: return 6;
            case 7: return 20;
            default: return 0;
        }
    }

    public static byte[] ReverseCopyKey(byte[] output, byte[] key)
    {
        output[0] = key[5];
        output[1] = key[4];
        output[2] = key[3];
        output[3] = key[2];
        output[4] = key[1];
        output[5] = key[0];
        return output;
    }

    public static void UnpackChip(byte[] output, byte[] chip)
    {
        output[6] = (byte)(((chip[6] & (1 << 7)) == 0) ? 1 : 0);  // Inverted 7th bit
        output[7] = (byte)(chip[6] & (1 << 6));                   // 6th bit only
        output[8] = ChipCheckCount(chip[6]);                      // Custom function
        output[9] = (byte)((chip[6] & 0b00000111) + 1);           // Last 3 bits + 1
        // output[10] = (byte)(chip[7] & 0b00111111);             // Old logic (commented)
    }

    public static void PackKey(byte[] @out, byte[] key)
    {
        Array.Copy(key.Reverse().ToArray(), @out, 6);
        byte ports = 0;
        for (var i = 0; i < 8; i++)
            ports |= (byte)((key[i + 6] != 0) ? (1 << i) : 0);
        @out[6] = ports;
        var persCat = key[14];
        if (persCat < 1 || persCat > 16)
            throw new InvalidOperationException("Personnel category out of range 1..16");
        --persCat;
        var suppressDoorEvent = key[15] != 0;
        var openEvenComplex = key[16] != 0;
        var isSilent = key[17] != 0;
        @out[7] = (byte)(persCat | (suppressDoorEvent ? (1 << 5) : 0) |
                         (openEvenComplex ? (1 << 6) : 0) | (isSilent ? (1 << 7) : 0));
    }

    public static void CheckRange(int min, int max, int val, string name)
    {
        if (val < min || val > max)
            throw new InvalidOperationException($"{name} out of range {min}..{max}.");
    }
}
