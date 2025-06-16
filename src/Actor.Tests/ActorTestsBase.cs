using Microsoft.Extensions.DependencyInjection;
using Shared.Tests;

namespace SevenSeals.Tss.Actor;

public abstract class ActorTestsBase<TClient> : TestBase where TClient : ActorBaseClient
{
    protected readonly ActorTestFactory Factory;

    protected ActorTestsBase()
    {
        Factory = new ActorTestFactory();
    }

    protected TClient OpenClient()
    {
        var scope = Factory.Services.CreateScope();
        return scope.ServiceProvider.GetRequiredService<TClient>();
    }

    protected virtual TRequest NewRequest<TRequest>() where TRequest : ActorRequestBase, new()
    {
        var request = new TRequest();
        return request;
    }
}
