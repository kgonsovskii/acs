using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace SevenSeals.Tss.Contour;

public static class Services
{
    public static void AddContourClients(this IServiceCollection services, IConfiguration configuration)
    {
        services.Configure<ContourClientOptions>(configuration.GetSection("ContourClient"));
        services.AddScoped<SpotClient>();
        services.AddScoped<DiagnosticClient>();
        services.AddScoped<SnapshotClient>();
        services.Configure<SpotOptions>(configuration.GetSection("SpotSettings"));
    }
}
