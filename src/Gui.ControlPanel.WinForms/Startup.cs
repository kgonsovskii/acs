using System.Text.Json;
using Gui.Shared;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Actor;

namespace Gui.ControlPanel.WinForms;

public class Startup : GuiStartupBase<Startup>
{
    public Startup(IConfiguration configuration) : base(configuration)
    {
    }

    protected override IServiceCollection ConfigureServicesInternal(IServiceCollection services)
    {
        services.AddScoped<MainForm>();
        services.AddActorClient(Configuration);
        return services;
    }

    protected override void ConfigureJsonInternal(JsonSerializerOptions opts)
    {
    }

    protected override void UseInternal(IApplicationBuilder app, IWebHostEnvironment env, ILogger<Startup> logger)
    {
    }
}
