using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Serilog;

namespace SevenSeals.Tss.Shared;

public abstract class ProgramBase<TStartup> where TStartup : class
{
    protected virtual int Run(string[] args)
    {
        Log.Logger = new LoggerConfiguration()
            .WriteTo.Console()
            .Enrich.FromLogContext()
            .CreateLogger();

        try
        {
            Log.Information("Starting up the host...");
            CreateHostBuilder(args).Build().Run();
        }
        catch (Exception ex)
        {
            Log.Fatal(ex, "Host terminated unexpectedly.");
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

                config
                    .AddJsonFile("appsettings.base.json", optional: false, reloadOnChange: true)
                    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                    .AddJsonFile($"appsettings.{environmentName}.json", optional: true, reloadOnChange: true);

                hostingContext.HostingEnvironment.EnvironmentName = environmentName;

                config
                    .SetBasePath(env.ContentRootPath)
                    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                    .AddJsonFile($"appsettings.{environmentName}.json", optional: true, reloadOnChange: true)
                    .AddEnvironmentVariables();
                config.AddCommandLine(args);
            })
            .ConfigureWebHostDefaults(webBuilder =>
            {
                webBuilder.UseStartup<TStartup>();
            });
}
