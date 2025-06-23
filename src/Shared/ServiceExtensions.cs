using Infra;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace SevenSeals.Tss.Shared;

public static class ServiceExtensions
{
    public static IServiceCollection ConfigureClientOptions<T>(this IServiceCollection services, IConfiguration configuration, string? sectionName = null) where T : class
    {
        sectionName ??= typeof(T).Name.ToCamelCase().Replace("Options","");
        services.Configure<T>(configuration.GetSection(sectionName));
        return services;
    }
}
