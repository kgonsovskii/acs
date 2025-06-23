using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared.Tests.Base;

namespace SevenSeals.Tss.Atlas;

public class AtlasTestFactory : TestWebAppFactory<Startup>
{
    protected override void ConfigureServices(WebHostBuilderContext context, IServiceCollection services)
    {
        services.AddAtlasClients(context.Configuration);
    }
}
