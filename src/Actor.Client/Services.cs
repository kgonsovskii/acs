using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public static class Services
{
    public static void AddActorClient(this IServiceCollection services, IConfiguration configuration)
    {
        services.ConfigureClientOptions<ActorClientOptions>(configuration);
        services.AddScoped<IActorClient, ActorClient>();
        services.AddScoped<IKeyClient, KeyClient>();
    }
}
