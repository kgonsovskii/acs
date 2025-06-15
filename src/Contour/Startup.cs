using System.Text.Json;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace SevenSeals.Tss.Contour;

public class Startup: Shared.StartupBase<Startup>
{
    private readonly IConfiguration _configuration;
    public Startup(IConfiguration configuration) : base(configuration)
    {
        _configuration = configuration;
    }

    protected override IServiceCollection ConfigureServicesInternal(IServiceCollection services)
    {
        services.AddExtendedOptions<ContourMap>(ServiceGroup, "map");
        services.Configure<SpotOptions>(_configuration.GetSection("spotOptions"));
        services.AddSingleton<AppState>();
        services.AddSingleton<AppSnapshot>();
        services.AddHostedService<AppHost>();
        services.AddSingleton<EventQueue>();
        services.AddSingleton<EventLog>();
        services.AddSingleton<ChannelHub>();
        services.AddSingleton<SpotHub>();
        return services;
    }

    protected override void ConfigureSwaggerInternal(SwaggerGenOptions opts)
    {
        opts.SelectDiscriminatorNameUsing(type =>
            type == typeof(ChannelOptions) ? "type" : null);
        opts.SelectSubTypesUsing(baseType =>
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
    }

    protected override void ConfigureJsonInternal(JsonSerializerOptions opts)
    {
        opts.Converters.Add(new ChannelOptionsJsonConverter());
    }

    protected override void UseInternal(IApplicationBuilder app, IWebHostEnvironment env, ILogger<Startup> logger)
    {
        //
    }
}
