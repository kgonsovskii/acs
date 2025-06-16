using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Shared.Tests;

namespace SevenSeals.Tss.Actor;

public class ActorTestFactory : TestWebAppFactory<Startup>
{
    protected override void ConfigureServices(WebHostBuilderContext context, IServiceCollection services)
    {
        services.AddActorClient(context.Configuration);
    }
}
