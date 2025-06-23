using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Shared.Tests.Base;

namespace SevenSeals.Tss.Logic;

public class LogicTestFactory:TestWebAppFactory<Startup>
{
    protected override void ConfigureServices(WebHostBuilderContext context, IServiceCollection services)
    {
        services.AddLogicClients(context.Configuration);
        services.AddContourClients(context.Configuration);
    }
}
