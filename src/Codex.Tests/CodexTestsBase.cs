using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared;
using Shared.Tests;

namespace SevenSeals.Tss.Codex;

public abstract class CodexTestsBase<TClient> : TestBase  where TClient : CodexBaseClient
{
    private readonly CodexTestFactory _factory = new();

    protected TClient OpenClient()
    {
        var scope = _factory.Services.CreateScope();
        return scope.ServiceProvider.GetRequiredService<TClient>();
    }

    protected virtual TRequest NewRequest<TRequest>() where TRequest : RequestBase, new()
    {
        var request = new TRequest();
        return request;
    }
}
