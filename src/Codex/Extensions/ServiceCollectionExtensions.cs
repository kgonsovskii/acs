using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Codex.Services;

namespace SevenSeals.Tss.Codex.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddCodexServices(this IServiceCollection services)
    {
        services.AddScoped<IRouteService, RouteService>();
        services.AddScoped<ITimeZoneRuleService, TimeZoneRuleService>();
        services.AddScoped<IAccessLevelService, AccessLevelService>();
        return services;
    }
} 