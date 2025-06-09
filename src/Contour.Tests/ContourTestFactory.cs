using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Shared.Tests;

namespace SevenSeals.Tss.Contour;

public class ContourTestFactory:TestWebAppFactory<Startup>
{
    protected override void ConfigureServices(WebHostBuilderContext context, IServiceCollection services)
    {
        services.AddContourClients(context.Configuration);
    }
}
