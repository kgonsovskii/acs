using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Codex;

public static class Services
{
    public static IServiceCollection AddCodexClient(this IServiceCollection services, IConfiguration configuration)
    {
        services.ConfigureClientOptions<CodexClientOptions>(configuration);
        services.AddScoped<IRouteClient, RouteClient>();
        services.AddScoped<ITimeZoneClient, TimeZoneClient>();
        return services;
    }
}
