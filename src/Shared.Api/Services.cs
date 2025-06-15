using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace SevenSeals.Tss.Shared;

public static class Services
{
    public static IServiceCollection ConfigureClientOptions<T>(this IServiceCollection services, IConfiguration configuration, string? sectionName = null) where T : class
    {
        sectionName ??= typeof(T).Name.ToCamelCase().Replace("Options","");
        services.Configure<T>(configuration.GetSection(sectionName));
        return services;
    }

    public static void ConfigureApiSwagger(this SwaggerGenOptions opts)
    {
        opts.UseOneOfForPolymorphism();
        opts.OperationFilter<ProtoSwaggerFilter>();
    }

    public static IApplicationBuilder UseApi(this IApplicationBuilder builder)
    {
        builder = builder.UseMiddleware<ProtoForwardMiddleware>();
        return builder.UseMiddleware<ProtoMiddleware>();
    }
}
