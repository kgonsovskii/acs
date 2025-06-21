using Infra;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Serilog;

namespace Gui.Shared;

public abstract class GuiProgramBase
{
    public abstract int Run(string[] args);
}
public abstract class GuiProgramBase<TGuiStartup>: GuiProgramBase where TGuiStartup : GuiStartupBase<TGuiStartup>
{
    public override int Run(string[] args)
    {
        Log.Logger = new LoggerConfiguration()
            .WriteTo.Console()
            .Enrich.FromLogContext()
            .CreateLogger();

        try
        {
            Log.Information("Starting up the GUI host...");
            CreateHostBuilder(args).Build().Run();
        }
        catch (Exception ex)
        {
            Log.Fatal(ex, "GUI Host terminated unexpectedly.");
            return 1;
        }
        finally
        {
            Log.CloseAndFlush();
        }

        return 0;
    }

    protected virtual IHostBuilder CreateHostBuilder(string[] args) =>
        Host.CreateDefaultBuilder(args)
            .UseSerilog()
            .ConfigureAppConfiguration((hostingContext, config) =>
            {
                var env = hostingContext.HostingEnvironment;

                config.Sources.Clear();
#if DEBUG
                var environmentName = "Development";
#else
                var environmentName = env.EnvironmentName;
#endif
                hostingContext.HostingEnvironment.EnvironmentName = environmentName;

                config
                    .SetBasePath(env.ContentRootPath)
                    .AddJsonFile($"appsettings.{ServiceGroup}.base.json", optional: false, reloadOnChange: true)
                    .AddJsonFile($"appsettings.{ServiceGroup}.json", optional: false, reloadOnChange: true)
                    .AddJsonFile($"appsettings.{ServiceGroup}.{environmentName}.json", optional: true, reloadOnChange: true)
                    .AddEnvironmentVariables();
                config.AddCommandLine(args);
            })
            .ConfigureWebHostDefaults(webBuilder =>
            {
                webBuilder.UseStartup<TGuiStartup>();
            });

    protected virtual string ServiceGroup => this.GetServiceGroup();
}
