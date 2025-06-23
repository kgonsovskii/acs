using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Logic;

public static class Services
{
    public static void AddLogicClients(this IServiceCollection services, IConfiguration configuration)
    {
        services.ConfigureClientOptions<LogicClientOptions>(configuration);
        services.AddScoped<ILogicClient, LogicClient>();

        services.ConfigureClientOptions<LogicClientOptions>(configuration);
        services.AddScoped<ILogicCallbackClient, LogicCallbackClient>();
    }
}
