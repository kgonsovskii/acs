using System.Text.Json;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace Gui.Shared;

public abstract class GuiStartupBase<TStartup> where TStartup : class
{
    protected IConfiguration Configuration {get;}

    protected GuiStartupBase(IConfiguration configuration)
    {
        Configuration = configuration;
    }

    protected abstract IServiceCollection ConfigureServicesInternal(IServiceCollection services);
    protected abstract void ConfigureJsonInternal(JsonSerializerOptions opts);
    protected abstract void UseInternal(IApplicationBuilder app, IWebHostEnvironment env, ILogger<TStartup> logger);

    public void ConfigureServices(IServiceCollection services)
    {
        services
            .ConfigureShared()
            .AddSingleton(new CommandLineArgs(Environment.GetCommandLineArgs()))
            .AddSingleton<Settings>()
            .AddHttpClient()
            .AddControllers(options =>
            {
                options.EnableEndpointRouting = true;
            })
            .AddJsonOptions(options =>
            {
                options.JsonSerializerOptions.ConfigureJson();
                ConfigureJsonInternal(options.JsonSerializerOptions);
            });

        ConfigureServicesInternal(services);
    }

    public void Configure(IApplicationBuilder app, IWebHostEnvironment env, ILogger<TStartup> logger)
    {
        UseInternal(app, env, logger);
    }

    protected virtual string ServiceGroup => "Gui";
}
