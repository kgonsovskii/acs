using System.Reflection;
using System.Text.Json;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;

namespace SevenSeals.Tss.Shared;

public abstract class StartupBase<TStartup> where TStartup : class
{
    protected IConfiguration Configuration {get;}

    protected StartupBase(IConfiguration configuration)
    {
        Configuration = configuration;
    }

    public virtual void ConfigureServices(IServiceCollection services)
    {
        services
            .AddSingleton(new CommandLineArgs(Environment.GetCommandLineArgs()))
            .AddSingleton<Settings>()
            .AddControllers()
            .AddJsonOptions(options =>
            {
                options.JsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
                options.JsonSerializerOptions.WriteIndented = true;
            });
        services
            .AddEndpointsApiExplorer()
            .AddSwaggerGen(c =>
            {
                c.EnableAnnotations();

                c.SwaggerDoc("v1", new OpenApiInfo
                {
                    Title = Assembly.GetEntryAssembly()!.GetName().Name,
                    Version = "v1",
                    Description = $"API for {Assembly.GetEntryAssembly()!.GetName().Name}",
                });

                var basePath = AppContext.BaseDirectory;
                var mainXml = Path.Combine(basePath, $"{Assembly.GetEntryAssembly()!.GetName().Name}.xml");
                if (File.Exists(mainXml))
                {
                    c.IncludeXmlComments(mainXml);
                }

                var asms = Assembly.GetEntryAssembly()!.GetReferencedAssemblies().ToArray();
                foreach (var referencedAssembly in asms)
                {
                    var xmlName = $"{referencedAssembly.Name}.xml";
                    var xmlPath = Path.Combine(basePath, xmlName);
                    if (File.Exists(xmlPath))
                    {
                        c.IncludeXmlComments(xmlPath);
                    }
                }
            });
    }

    public virtual void Configure(IApplicationBuilder app, IWebHostEnvironment env, ILogger<TStartup> logger)
    {
        logger.LogInformation("Environment: {EnvironmentName}", env.EnvironmentName);

        if (env.IsDevelopment())
        {
            app.UseDeveloperExceptionPage();
        }

        app.UseRouting();

        app.UseSwagger();
        app.UseSwaggerUI(c =>
        {
            c.SwaggerEndpoint("/swagger/v1/swagger.json", Assembly.GetEntryAssembly()!.FullName);
            c.RoutePrefix = "swagger";
        });

        app.UseEndpoints(endpoints =>
        {
            endpoints.MapControllers();
        });
    }
}
