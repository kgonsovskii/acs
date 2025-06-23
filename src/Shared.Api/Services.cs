using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace SevenSeals.Tss.Shared;

public static class Services
{
    public static void ConfigureApiSwagger(this SwaggerGenOptions opts)
    {
        opts.UseOneOfForPolymorphism();
        opts.OperationFilter<ProtoSwaggerFilter>();
    }

    public static IApplicationBuilder UseApi(this IApplicationBuilder builder)
    {
        builder = builder.UseMiddleware<ProtoForwardMiddleware>();
        return builder;
    }
}
