using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Shared;
using Shared.Tests;

namespace SevenSeals.Tss.Atlas;

public abstract class AtlasTestsBase<TClient> : TestBase where TClient : AtlasBaseClient
{
    protected readonly AtlasTestFactory Factory;

    protected AtlasTestsBase()
    {
        Factory = new AtlasTestFactory();
    }

    protected TClient OpenClient()
    {
        var scope = Factory.Services.CreateScope();
        return scope.ServiceProvider.GetRequiredService<TClient>();
    }

    protected virtual TRequest NewRequest<TRequest>() where TRequest : AtlasRequestBase, new()
    {
        var request = new TRequest();
        return request;
    }
} 