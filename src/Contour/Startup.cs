using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class Startup: Shared.StartupBase<Startup>
{
    private readonly IConfiguration _configuration;
    public Startup(IConfiguration configuration) : base(configuration)
    {
        _configuration = configuration;
    }

    public override void ConfigureServices(IServiceCollection services)
    {
        base.ConfigureServices(services);
        services.AddExtendedOptions<ContourMap>("map");
        services.Configure<SpotOptions>(_configuration.GetSection("spotOptions"));
        services.AddSingleton<AppState>();
        services.AddSingleton<AppSnapshot>();
        services.AddHostedService<AppHost>();
        services.AddSingleton<EventQueue>();
        services.AddSingleton<EventLog>();
        services.AddSingleton<ChannelHub>();
        services.AddSingleton<SpotHub>();
    }

    public override void Configure(IApplicationBuilder app, IWebHostEnvironment env, ILogger<Startup> logger)
    {
        //
        base.Configure(app, env, logger);
    }
}
