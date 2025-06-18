using System.Diagnostics.CodeAnalysis;
using System.Text.Json;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Codex.Storage;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace SevenSeals.Tss.Codex;

[SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
public class Startup: Shared.StartupBase<Startup>
{
    public Startup(IConfiguration configuration) : base(configuration)
    {
    }

    protected override IServiceCollection ConfigureServicesInternal(IServiceCollection services)
    {
        services.AddSingleton<ITimeZoneStorage, TimeZoneStorage>();
        services.AddSingleton<IRouteStorage, RouteStorage>();
        return services;
    }

    protected override void ConfigureSwaggerInternal(SwaggerGenOptions opts)
    {
        //
    }

    protected override void ConfigureJsonInternal(JsonSerializerOptions opts)
    {
        //
    }

    protected override void UseInternal(IApplicationBuilder app, IWebHostEnvironment env, ILogger<Startup> logger)
    {
        //
    }
}
