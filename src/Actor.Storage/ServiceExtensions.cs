using Microsoft.Extensions.DependencyInjection;

namespace SevenSeals.Tss.Actor;

public static class ServiceExtensions
{
    public static IServiceCollection AddActorStorage(this IServiceCollection services)
    {
        services.AddSingleton<IActorStorage, ActorStorage>();
        services.AddSingleton<IKeyStorage, KeyStorage>();
        return services;
    }
}
