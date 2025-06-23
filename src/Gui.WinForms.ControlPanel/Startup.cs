using System.Text.Json;
using Gui.Shared;
using JetBrains.Annotations;
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
using SevenSeals.Tss.Logic;

namespace Gui.WinForms;

[UsedImplicitly]
public class Startup : GuiStartupBase<Startup>
{
    public Startup(IConfiguration configuration) : base(configuration)
    {
    }

    protected override IServiceCollection ConfigureServicesInternal(IServiceCollection services)
    {
        services.AddHostedService<MainHost>();
        services.AddActorClients(Configuration);
        services.AddAtlasClients(Configuration);
        services.AddContourClients(Configuration);
        services.AddCodexClients(Configuration);
        services.AddChronicleClients(Configuration);
        services.AddLogicClients(Configuration);
        services.AddScoped<MainForm>(provider => new MainForm(
            provider.GetRequiredService<IMemberClient>(),
            provider.GetRequiredService<IPassClient>(),
            provider.GetRequiredService<IAtlasClient>(),
            provider.GetRequiredService<IZoneClient>(),
            provider.GetRequiredService<ITransitClient>(),
            provider.GetRequiredService<ISpotClient>(),
            provider.GetRequiredService<IRouteClient>(),
            provider.GetRequiredService<ITimeZoneClient>(),
            provider.GetRequiredService<IContourClient>(),
            provider.GetRequiredService<ILogicClient>()
        ));
        return services;
    }

    protected override void ConfigureJsonInternal(JsonSerializerOptions opts)
    {
    }

    protected override void UseInternal(IApplicationBuilder app, IWebHostEnvironment env, ILogger<Startup> logger)
    {
    }
}
