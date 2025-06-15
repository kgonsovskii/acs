using System.Text.Json;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Codex.Services;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace SevenSeals.Tss.Codex;

public class Startup: Shared.StartupBase<Startup>
{
    public Startup(IConfiguration configuration) : base(configuration)
    {
    }

    protected override IServiceCollection ConfigureServicesInternal(IServiceCollection services)
    {
        services.AddScoped<ITimeZoneService, TimeZoneService>();
        services.AddScoped<IRouteService, RouteService>();
        services.AddScoped<IAccessLevelService, AccessLevelService>();
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
