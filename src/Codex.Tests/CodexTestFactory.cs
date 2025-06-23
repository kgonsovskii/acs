using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared.Tests.Base;

namespace SevenSeals.Tss.Codex;

public class CodexTestFactory : TestWebAppFactory<Startup>
{
    protected override void ConfigureServices(WebHostBuilderContext context, IServiceCollection services)
    {
        services.AddCodexClients(context.Configuration);
    }
}
