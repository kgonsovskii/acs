using System;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;

namespace Tss
{
    public static class Sys
    {
        public static void Log(string s)
        {
            var now = DateTime.Now;
            string logLine = $"{now:yyyy-MM-dd_HH:mm:ss} {s}";
            Console.WriteLine(logLine);

#if DEBUG
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                Debug.WriteLine($"{now:HH:mm:ss} {s}");
            }
#endif
        }

        public static void HandleException(Exception e, string prefix = null, string suffix = null)
        {
            if (e is AbortException)
                return;

            var sb = new StringBuilder();
            if (!string.IsNullOrEmpty(prefix))
                sb.Append(prefix + " ");
            sb.Append(e.Message);
            if (!string.IsNullOrEmpty(suffix))
                sb.Append(" " + suffix);

            Log(sb.ToString());

            if (e is FatalErrorException)
                Environment.Exit(-1);
        }

        public static string ErrDesc(int ec)
        {
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                return new System.ComponentModel.Win32Exception(ec).Message;
            }
            else
            {
                // On Linux, use strerror
                return Marshal.PtrToStringAnsi(strerror(ec));
            }
        }

        [DllImport("libc")]
        private static extern IntPtr strerror(int errnum);

        public static string ErrMsg(string msg, int ec)
        {
            return $"{msg}; OS ec: {ec}, desc: '{ErrDesc(ec)}'.";
        }
    }

    // Custom exceptions for compatibility
    public class AbortException : Exception { }
    public class FatalErrorException : Exception { }
} 