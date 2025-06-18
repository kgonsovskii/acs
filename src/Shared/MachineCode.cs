using System.Net.NetworkInformation;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;

namespace SevenSeals.Tss.Shared;

public static class MachineCode
{
    private static string? _machineCode;

    public static string GetMachineCode()
    {
        if (!string.IsNullOrEmpty(_machineCode))
            return _machineCode;

        try
        {
            var biosSerial = GetBiosSerialNumber() ?? "";
            var motherboardSerial = GetMotherboardSerialNumber() ?? "";

            var macAddress = NetworkInterface
                .GetAllNetworkInterfaces()
                .Where(nic => nic.OperationalStatus == OperationalStatus.Up &&
                              nic.NetworkInterfaceType != NetworkInterfaceType.Loopback)
                .Select(nic => nic.GetPhysicalAddress().ToString())
                .FirstOrDefault() ?? "";

            var fallbackId = GetPlatformSpecificId() ?? "";

            var combined = biosSerial + motherboardSerial + macAddress + fallbackId;

            if (string.IsNullOrEmpty(combined))
                combined = "HephaestusFallback";

            using var sha256 = SHA256.Create();
            var bytes = Encoding.UTF8.GetBytes(combined);
            var hash = sha256.ComputeHash(bytes);

            var base64 = Convert.ToBase64String(hash);
            var clean = new string(base64.Where(char.IsLetterOrDigit).ToArray());

            _machineCode = clean.Substring(0, Math.Min(12, clean.Length));

            return _machineCode;
        }
        catch
        {
            return "Hephaestus";
        }
    }

    private static string? GetBiosSerialNumber()
    {
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            return null;
        }

        if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
        {
            const string path = "/sys/class/dmi/id/product_serial";
            if (!File.Exists(path))
                return null;
            try
            {
                return File.ReadAllText(path).Trim();
            }
            catch
            {
                // ignored
            }
        }
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
        {
            // macOS: Use system_profiler SPHardwareDataType | grep Serial
            // Calling process is required, let's skip or implement if needed
        }
        return null;
    }

    private static string? GetMotherboardSerialNumber()
    {
        if (!RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            return null;
        const string path = "/sys/class/dmi/id/board_serial";

        if (!File.Exists(path)) return null;
        try
        {
            return File.ReadAllText(path).Trim();
        }
        catch
        {
            // ignored
        }
        return null;
    }

    private static string? GetPlatformSpecificId()
    {
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
        {
            string[] paths = ["/etc/machine-id", "/var/lib/dbus/machine-id"];
            foreach (var path in paths)
            {
                if (File.Exists(path))
                {
                    try
                    {
                        var id = File.ReadAllText(path).Trim();
                        if (!string.IsNullOrEmpty(id))
                            return id;
                    }
                    catch
                    {
                        // ignored
                    }
                }
            }
        }
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX) || RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            try
            {
                return Environment.MachineName;
            }
            catch
            {
                // ignored
            }
        }

        return null;
    }
}
