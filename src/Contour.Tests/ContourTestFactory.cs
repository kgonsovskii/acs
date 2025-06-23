using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared.Tests.Base;

namespace SevenSeals.Tss.Contour;

public class ContourTestFactory:TestWebAppFactory<Startup>
{
    protected override void ConfigureServices(WebHostBuilderContext context, IServiceCollection services)
    {
        services.AddContourClients(context.Configuration);
    }
}
