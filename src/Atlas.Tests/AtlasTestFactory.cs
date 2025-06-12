using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Shared.Tests;

namespace SevenSeals.Tss.Atlas;

public class AtlasTestFactory : TestWebAppFactory<Startup>
{
    protected override void ConfigureServices(WebHostBuilderContext context, IServiceCollection services)
    {
        services.AddAtlasClient(context.Configuration);
    }
}
