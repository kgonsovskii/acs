using System.Reflection;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
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
            .ConfigureShared()
            .AddSingleton(new CommandLineArgs(Environment.GetCommandLineArgs()))
            .AddSingleton<Settings>()
            .AddHttpClient()
            .AddControllers().AddJsonOptions(options => options.JsonSerializerOptions.ConfigureJson());
        services
            .AddEndpointsApiExplorer()
            .AddSwaggerGen(c =>
            {
                c.EnableAnnotations();

                c.UseOneOfForPolymorphism();

                c.SelectDiscriminatorNameUsing(type =>
                   type == typeof(ChannelOptions) ? "type" : null);

                c.SelectSubTypesUsing(baseType =>
                {
                    if (baseType == typeof(ChannelOptions))
                    {
                        return new[]
                        {
                            typeof(IpOptions),
                            typeof(ComPortOptions)
                        };
                    }
                    return Enumerable.Empty<Type>();
                });

                c.SwaggerDoc("v1", new OpenApiInfo
                {
                    Title = Assembly.GetEntryAssembly()!.GetName().Name,
                    Version = "v1",
                    Description = $"API for {Assembly.GetEntryAssembly()!.GetName().Name}"
                });

                // Add schema filter for dynamic default values
                c.SchemaFilter<SwaggerDefaultValueFilter>();

                // Add X-Forward-To header filter
                c.OperationFilter<XForwardToHeaderFilter>();

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
            });
    }

    public virtual void Configure(IApplicationBuilder app, IWebHostEnvironment env, ILogger<TStartup> logger)
    {
        logger.LogInformation("Environment: {EnvironmentName}", env.EnvironmentName);

        app.UseDeveloperExceptionPage();

        app.UseRouting();

        app.UseMiddleware<ForwardingMiddleware>();

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
    }
}
