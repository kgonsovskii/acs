using Infra;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Serilog;

namespace SevenSeals.Tss.Shared;

public abstract class ProgramBase
{
    public abstract Task Run(string[] args);
}

public abstract class ProgramBase<TStartup>: ProgramBase where TStartup : StartupBase<TStartup>
{
    protected virtual Type AppId => GetType();
    private GenericHost GenericHost => GenericHost.GetOrCreate(AppId);

    public override async Task Run(string[] args)
    {
        Log.Logger = new LoggerConfiguration()
            .WriteTo.Console()
            .MinimumLevel.Warning()
            .Enrich.FromLogContext()
            .CreateLogger();

        try
        {
            Log.Warning("Starting up the host {AppId}...", AppId);
            var host = CreateHostBuilder(args).Build();
            GenericHost.Initialize(host);
            await host.RunAsync(GenericHost.ShutdownToken);
        }
        catch (OperationCanceledException)
        {
            Log.Warning("Host {AppId} shutdown requested.", AppId);
        }
        catch (Exception ex)
        {
            Log.Fatal(ex, "Host {AppId} terminated unexpectedly.", AppId);
        }
        finally
        {
            Log.CloseAndFlush();
        }
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

                var basePath = env.ContentRootPath;

                config
                    .SetBasePath(env.ContentRootPath)
                    .AddJsonFile(Path.Combine(basePath, $"appsettings.{ServiceGroup}.base.json"), optional: false, reloadOnChange: true)
                    .AddJsonFile(Path.Combine(basePath, $"appsettings.{ServiceGroup}.json"), optional: false, reloadOnChange: true)
                    .AddJsonFile(Path.Combine(basePath, $"appsettings.{ServiceGroup}.{environmentName}.json"), optional: true, reloadOnChange: true)
                    .AddEnvironmentVariables();
                config.AddCommandLine(args);
            })
            .ConfigureWebHostDefaults(webBuilder =>
            {
                webBuilder.UseStartup<TStartup>();
            });

    protected virtual string ServiceGroup => this.GetServiceGroup();
}
