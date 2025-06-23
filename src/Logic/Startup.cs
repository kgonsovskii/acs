using System.Text.Json;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Actor;
using SevenSeals.Tss.Atlas;
using SevenSeals.Tss.Chronicle;
using SevenSeals.Tss.Codex;
using SevenSeals.Tss.Contour;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace SevenSeals.Tss.Logic;

public class Startup: Shared.StartupBase<Startup>
{
    public Startup(IConfiguration configuration) : base(configuration)
    {
    }

    protected override IServiceCollection ConfigureServicesInternal(IServiceCollection services)
    {
        services.AddHostedService<AppHost>();
        services.AddSingleton<ClientEvents>();
        services.AddScoped<ILogicService, LogicService>();
        services.AddActorClients(Configuration);
        services.AddAtlasClients(Configuration);
        services.AddContourClients(Configuration);
        services.AddCodexClients(Configuration);
        services.AddChronicleClients(Configuration);
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
