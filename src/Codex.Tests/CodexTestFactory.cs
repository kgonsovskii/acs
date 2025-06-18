using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Codex;

public class CodexTestFactory : TestWebAppFactory<Startup>
{
    protected override void ConfigureServices(WebHostBuilderContext context, IServiceCollection services)
    {
        services.AddCodexClient(context.Configuration);
    }
}
