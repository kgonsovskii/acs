using Microsoft.Extensions.DependencyInjection;

namespace SevenSeals.Tss.Codex.Storage;

public static class ServiceExtensions
{
    public static IServiceCollection AddCodexStorage(this IServiceCollection services)
    {
        services.AddSingleton<IRouteStorage, RouteStorage>();
        services.AddSingleton<ITimeZoneStorage, TimeZoneStorage>();
        return services;
    }
} 