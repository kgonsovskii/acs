using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace SevenSeals.Tss.Contour;

public static class Services
{
    public static void AddContourClients(this IServiceCollection services, IConfiguration configuration)
    {
        services.Configure<ContourClientOptions>(configuration.GetSection("contourClient"));
        services.AddScoped<ContourClient>();
        services.AddScoped<DiagnosticClient>();
        services.Configure<SpotOptions>(configuration.GetSection("spotSettings"));
    }
}
