using System.Text.Json;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
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
        services.AddContourStorage();
        services.Configure<ContourOptions>(_configuration.GetSection("contourOptions"));
        services.AddSingleton<AppState>();
        services.AddSingleton<AppSnapshot>();
        services.AddHostedService<AppHost>();

        services.AddSingleton<ChannelHub>();
        services.AddSingleton<ContourHub>();

        services.AddSingleton<EventQueue>();
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
                return
                [
                    typeof(IpOptions),
                    typeof(ComPortOptions)
                ];
            }
            return [];
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
