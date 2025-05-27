using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;

namespace SevenSeals.Tss.Shared;

public static class Sys
{
    public static void Log(string message)
    {
        // Simple log to console, can be replaced with more advanced logging
        Console.WriteLine(message);
    }

    public static void HandleException(Exception ex, string msg1 = null, string msg2 = null)
    {
        Log($"Exception: {ex.Message} {msg1 ?? ""} {msg2 ?? ""}");
    }

    public class Abort : Exception
    {
        public Abort() : base("Abort") { }
    }

    public class FatalError : Exception
    {
        public FatalError(string msg) : base(msg) { }
    }

#if DEBUG
    public static void Trace(string s) { Log(s); }
#else
        public static void Trace(string s) { }
#endif

    public static bool Even<T>(T x) where T : struct, IConvertible
    {
        return Convert.ToInt64(x) % 2 == 0;
    }

    public static bool Odd<T>(T x) where T : struct, IConvertible
    {
        return Convert.ToInt64(x) % 2 != 0;
    }

    public static void ExpandMask<TOut, TMask>(TOut[] outArr, TMask mask)
        where TOut : struct
        where TMask : struct, IConvertible
    {
        int bitCount = Marshal.SizeOf(typeof(TMask)) * 8;
        long maskVal = Convert.ToInt64(mask);
        for (int i = 0; i < bitCount; ++i)
            outArr[i] = (TOut)Convert.ChangeType(((maskVal & (1L << i)) != 0), typeof(TOut));
    }

    public static string HexDump(byte[] buf)
    {
        var sb = new StringBuilder();
        foreach (var b in buf)
            sb.AppendFormat("{0:X2} ", b);
        if (sb.Length > 0)
            sb.Length -= 1; // Remove last space
        return sb.ToString();
    }

    public static byte Bcd2Bin(byte val)
    {
        return (byte)((val & 0x0F) + 10 * ((val & 0xF0) >> 4));
    }

    public static byte Bin2Bcd(byte val)
    {
        byte x = (byte)(val / 10);
        return (byte)((x << 4) + (val - (x * 10)));
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
        if (buf.Length < 2) throw new ArgumentException("Buffer too small");
        return (short)(isBigEndian ? (buf[1] | (buf[0] << 8)) : ((buf[1] << 8) | buf[0]));
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
        if (buf.Length < 4) throw new ArgumentException("Buffer too small");
        return (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
    }

    public static string ErrMsg(string msg, int ec)
    {
        return $"{msg}: {ec} ({Os.ErrDesc(ec)})";
    }

    public static string ErrMsg(Exception ex)
    {
        return ex.Message;
    }

    public static class Os
    {
        public static int ErrNo()
        {
            // .NET does not expose errno directly; use Marshal.GetLastWin32Error for Windows
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
                return Marshal.GetLastWin32Error();
            else
                return 0; // Not available on Linux in .NET Standard
        }

        public static string ErrDesc(int ec)
        {
            try
            {
                return new System.ComponentModel.Win32Exception(ec).Message;
            }
            catch
            {
                return $"Unknown error {ec}";
            }
        }

        public static void ThrowException<T>() where T : Exception, new()
        {
            throw new T();
        }

        public static void FatalError()
        {
            throw new FatalError(ErrDesc(ErrNo()));
        }
    }

    public static uint TimeDiff(uint start, out uint now)
    {
        now = (uint)Environment.TickCount;
        return now - start;
    }

    public static uint TimeDiff(uint start)
    {
        uint now;
        return TimeDiff(start, out now);
    }

    public static class MyThread
    {
        public static void Sleep(uint ms)
        {
            System.Threading.Thread.Sleep((int)ms);
        }

        public static void Yield()
        {
            System.Threading.Thread.Yield();
        }

        public static int Id()
        {
            return System.Threading.Thread.CurrentThread.ManagedThreadId;
        }
    }

    public static class MyProcess
    {
        public static int Id()
        {
            return Process.GetCurrentProcess().Id;
        }

        public static bool Exists(int pid)
        {
            try
            {
                // This throws if process doesn't exist.
                _ = Process.GetProcessById(pid);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static bool Kill(int pid)
        {
            try
            {
                var proc = Process.GetProcessById(pid);
                proc.Kill();
                return true;
            }
            catch
            {
                return false;
            }
        }
    }


    public static class DelphiTDateTime
    {
        public const int EpochDiff = 25569;
        public const int SecsPerDay = 86400;

        public static double To(DateTime val)
        {
            return val.Subtract(new DateTime(1899, 12, 30)).TotalDays;
        }

        public static DateTime From(double val)
        {
            return new DateTime(1899, 12, 30).AddDays(val);
        }
    }
}
