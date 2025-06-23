using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Chronicle;

public static class Services
{
    public static void AddChronicleClients(this IServiceCollection services, IConfiguration configuration)
    {
        services.ConfigureClientOptions<ChronicleClientOptions>(configuration);
        services.AddScoped<IChronicleClient, ChronicleClient>();
    }
}
