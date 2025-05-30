using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Shared;
using Shared.Tests;

namespace Contour.Tests;

public abstract class ContourTestsBase<TClient>: TestBase  where TClient : ContourBaseClient
{
    protected readonly ContourTestFactory Factory;
    protected readonly TestSettings Settings;

    protected  ContourTestsBase()
    {
        Factory = new ContourTestFactory();
        Settings = Factory.Services.GetRequiredService<IOptions<TestSettings>>().Value;
    }

    protected TClient OpenClient()
    {
        var scope = Factory.Services.CreateScope();
        return scope.ServiceProvider.GetRequiredService<TClient>();
    }

    protected virtual TRequest NewRequest<TRequest>() where TRequest : SpotRequest, new()
    {
        var request = new TRequest()
        {
            Address = Settings.TestAddress,
            Host = Settings.TestHost,
            Port = Settings.TestPort
        };
        return request;
    }

    protected virtual TRequest NewBaseRequest<TRequest>() where TRequest : RequestBase, new()
    {
        var request = new TRequest();
        return request;
    }
}
