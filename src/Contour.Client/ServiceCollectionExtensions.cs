using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace SevenSeals.Tss.Contour;

public static class ServiceCollectionExtensions
{
    public static void AddContourClient(this IServiceCollection services, IConfiguration configuration)
    {
        services.Configure<ContourClientOptions>(configuration.GetSection("ContourClient"));
        services.AddScoped<ContourClient>();
    }
}
