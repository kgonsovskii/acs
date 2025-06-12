using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public static class Services
{
    public static IServiceCollection AddAtlasServices(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddSingleton<AtlasStorage>();
        return services;
    }
}
