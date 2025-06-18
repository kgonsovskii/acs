using System.Diagnostics.CodeAnalysis;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestTools.UnitTesting;

#pragma warning disable CS8618 // Non-nullable field must contain a non-null value when exiting constructor. Consider adding the 'required' modifier or declaring as nullable.

namespace SevenSeals.Tss.Shared;

public abstract class TestBase
{
protected void Log(string message)
    {
        TestContext.WriteLine(message);
    }
    [SuppressMessage("ReSharper", "UnusedAutoPropertyAccessor.Global")] public TestContext TestContext { get; set; }
}

public abstract class TestBase<TClient, TFactory, TStartup> : TestBase
    where TClient: IProtoClient
    where TFactory: TestWebAppFactory<TStartup>, new()
    where TStartup: class
{
    protected readonly TestWebAppFactory<TStartup> Factory = new TFactory();

    protected TClient OpenClient()
    {
        var scope = Factory.Services.CreateScope();
        return scope.ServiceProvider.GetRequiredService<TClient>();
    }

    protected virtual TRequest NewRequest<TRequest>() where TRequest : IProtoRequest, new()
    {
        var request = new TRequest();
        return request;
    }
}
