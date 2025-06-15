using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Shared.Tests;

namespace SevenSeals.Tss.Codex;

public class CodexTestFactory :TestWebAppFactory<Startup>
{
    protected override void ConfigureServices(WebHostBuilderContext context, IServiceCollection services)
    {
        services.AddCodexClient(context.Configuration);
    }
}
