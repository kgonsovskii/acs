using Microsoft.Extensions.DependencyInjection;

namespace SevenSeals.Tss.Atlas;

public static class ServiceExtensions
{
    public static IServiceCollection AddAtlasStorage(this IServiceCollection services)
    {
        services.AddSingleton<IZoneStorage, ZoneStorage>();
        services.AddSingleton<ITransitStorage, TransitStorage>();
        return services;
    }
} 