using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Contour;
using Shared.Tests;

namespace Contour.Tests;

public class ContourTestFactory:TestWebAppFactory<Startup>
{
    protected override void ConfigureServices(WebHostBuilderContext context, IServiceCollection services)
    {
        services.AddContourClients(context.Configuration);
        services.Configure<TestSettings>(context.Configuration.GetSection("TestSettings"));
    }
}
