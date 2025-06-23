using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Logic;

public class LogicTestFactory:TestWebAppFactory<Startup>
{
    protected override void ConfigureServices(WebHostBuilderContext context, IServiceCollection services)
    {
        services.AddContourClients(context.Configuration);
    }
}
