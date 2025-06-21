using System.Reflection;
using System.Text.Json;
using Infra;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace SevenSeals.Tss.Shared;

public abstract class StartupBase<TStartup> where TStartup : class
{
    protected IConfiguration Configuration {get;}

    protected StartupBase(IConfiguration configuration)
    {
        Configuration = configuration;
    }

    protected abstract IServiceCollection ConfigureServicesInternal(IServiceCollection services);
    protected abstract void ConfigureSwaggerInternal(SwaggerGenOptions opts);
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

        services
            .AddEndpointsApiExplorer()
            .AddSwaggerGen(c =>
            {
                c.ConfigureApiSwagger();
                c.EnableAnnotations();

                var name = this.GetServiceGroup();

                c.SwaggerDoc("v1", new OpenApiInfo
                {
                    Title = name,
                    Version = "v1",
                    Description = $"API for {name}"
                });

                var basePath = AppContext.BaseDirectory;
                var mainXml = Path.Combine(basePath, $"{Assembly.GetEntryAssembly()!.GetName().Name}.xml");
                if (File.Exists(mainXml))
                {
                    c.IncludeXmlComments(mainXml);
                }

                foreach (var referencedAssembly in Assembly.GetEntryAssembly()!.GetReferencedAssemblies())
                {
                    var xmlName = $"{referencedAssembly.Name}.xml";
                    var xmlPath = Path.Combine(basePath, xmlName);
                    if (File.Exists(xmlPath))
                    {
                        c.IncludeXmlComments(xmlPath);
                    }
                }
                ConfigureSwaggerInternal(c);
            });
        ConfigureServicesInternal(services);
    }

    public void Configure(IApplicationBuilder app, IWebHostEnvironment env, ILogger<TStartup> logger)
    {
        app.UseApi();

        logger.LogInformation("Environment: {EnvironmentName}", env.EnvironmentName);

        if (env.IsDevelopment())
        {
            app.UseDeveloperExceptionPage();
        }

        app.UseRouting();

        app.UseSwagger();
        app.UseSwaggerUI(c =>
        {
            c.SwaggerEndpoint("/swagger/v1/swagger.json", Assembly.GetEntryAssembly()!.GetName().Name);
            c.RoutePrefix = "swagger";
        });

        app.UseEndpoints(endpoints =>
        {
            endpoints.MapControllers();
        });

        UseInternal(app, env, logger);
    }

    protected virtual string ServiceGroup => this.GetServiceGroup();
}
