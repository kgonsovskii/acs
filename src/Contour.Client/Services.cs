using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public static class Services
{
    public static void AddContourClients(this IServiceCollection services, IConfiguration configuration)
    {
        services.ConfigureClientOptions<ContourClientOptions>(configuration);
        services.AddScoped<ContourClient>();
        services.AddScoped<DiagnosticClient>();
        services.Configure<SpotOptions>(configuration.GetSection("spotSettings"));
    }
}
