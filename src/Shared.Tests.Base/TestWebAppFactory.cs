using Infra;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace SevenSeals.Tss.Shared;

public abstract class TestWebAppFactory<TStartup> : WebApplicationFactory<TStartup> where TStartup : class
{
    protected override IHostBuilder CreateHostBuilder()
    {
        return Host.CreateDefaultBuilder()
            .ConfigureAppConfiguration((context, configBuilder) =>
            {
                configBuilder.Sources.Clear();

                var group = this.GetServiceGroup();

                configBuilder
                    .SetBasePath(Directory.GetCurrentDirectory())
                    .AddJsonFile($"appsettings.{group}.base.json", optional: false, reloadOnChange: true)
                    .AddJsonFile($"appsettings.{group}.json", optional: false, reloadOnChange: true)
                    .AddJsonFile($"appsettings.{group}.Development.json", optional: false, reloadOnChange: true)
                    .AddJsonFile($"appsettings.{group}.Test.json", optional: false, reloadOnChange: true)
                    .AddEnvironmentVariables();
            })
            .ConfigureWebHostDefaults(webBuilder =>
            {
                webBuilder.UseStartup<TStartup>();
            });
    }

    protected abstract void ConfigureServices(WebHostBuilderContext context, IServiceCollection services);

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.ConfigureServices((context, services) =>
        {
            var httpClientDescriptors = services.Where(d => d.ServiceType == typeof(HttpClient)).ToList();
            foreach (var desc in httpClientDescriptors)
                services.Remove(desc);
            services.AddTransient<HttpClient>(_ =>
            {
                return CreateClient();
            })
            .ConfigureShared();
            ConfigureServices(context, services);
        })
            .ConfigureLogging(logging =>
        {
            logging.ClearProviders();
            logging.AddConsole();
            logging.SetMinimumLevel(LogLevel.Information);
        });
    }
}
