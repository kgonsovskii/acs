using System.Text.Json;
using JetBrains.Annotations;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace SevenSeals.Tss.Actor;

[UsedImplicitly]
public class Startup : Shared.StartupBase<Startup>
{
    public Startup(IConfiguration configuration) : base(configuration){}
    protected override IServiceCollection ConfigureServicesInternal(IServiceCollection services)
    {
        services.AddActorStorage();
        return services;
    }

    protected override void ConfigureSwaggerInternal(SwaggerGenOptions opts)
    {
        //
    }

    protected override void ConfigureJsonInternal(JsonSerializerOptions opts)
    {
        //
    }

    protected override void UseInternal(IApplicationBuilder app, IWebHostEnvironment env, ILogger<Startup> logger)
    {
        //
    }
}
