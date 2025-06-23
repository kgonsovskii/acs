using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared.Tests.Base;

namespace SevenSeals.Tss.Actor;

public class ActorTestFactory : TestWebAppFactory<Startup>
{
    protected override void ConfigureServices(WebHostBuilderContext context, IServiceCollection services)
    {
        services.AddActorClients(context.Configuration);
    }
}
