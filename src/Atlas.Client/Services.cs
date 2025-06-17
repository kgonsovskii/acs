using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public static class Services
{
    public static IServiceCollection AddAtlasClient(this IServiceCollection services, IConfiguration configuration)
    {
        services.ConfigureClientOptions<AtlasClientOptions>(configuration);
        services.AddScoped<AtlasClient>();
        services.AddScoped<TransitClient>();
        services.AddScoped<ZoneClient>();
        return services;
    }
}
