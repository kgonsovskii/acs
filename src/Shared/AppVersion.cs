using System.Reflection;

namespace SevenSeals.Tss.Shared;

public static class AppVersion
{
    public static string Version { get; } = (typeof(AppVersion).Assembly.GetCustomAttribute<AssemblyInformationalVersionAttribute>()?.InformationalVersion ?? "unknown").Split('+')[0];
}
