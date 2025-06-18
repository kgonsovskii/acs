using System.Diagnostics.CodeAnalysis;
using System.Text.Json;
using JetBrains.Annotations;
using SevenSeals.Tss.Actor.Storage;
using SevenSeals.Tss.Shared;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace SevenSeals.Tss.Actor;

[UsedImplicitly]
public class Startup : Shared.StartupBase<Startup>
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public Startup(IConfiguration configuration) : base(configuration){}
    protected override IServiceCollection ConfigureServicesInternal(IServiceCollection services)
    {
        services.AddSingleton<IActorStorage, ActorStorage>();
        services.AddSingleton<IKeyStorage, KeyStorage>();
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
