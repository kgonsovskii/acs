using Microsoft.Extensions.DependencyInjection;

namespace SevenSeals.Tss.Contour;

public static class ServiceExtensions
{
    public static IServiceCollection AddContourStorage(this IServiceCollection services)
    {
        services.AddSingleton<ISpotStorage, SpotStorage>();
        services.AddSingleton<IEventLogStorage, EventLogStorage>();
        return services;
    }
}
