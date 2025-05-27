using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace SevenSeals.Tss.Contour;

public class Startup: Shared.StartupBase<Startup>
{
    public Startup(IConfiguration configuration) : base(configuration)
    {
    }

    public override void ConfigureServices(IServiceCollection services)
    {
        base.ConfigureServices(services);

        services.AddSingleton<AppState>();
        services.AddHostedService<AppHost>();
        services.AddSingleton<EventQueue>();
        services.AddSingleton<EventLog>();
        services.AddSingleton<ChannelHub>();
    }

    public override void Configure(IApplicationBuilder app, IWebHostEnvironment env, ILogger<Startup> logger)
    {
        //
        base.Configure(app, env, logger);
    }
}
