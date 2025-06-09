using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;
using Shared.Tests;

namespace SevenSeals.Tss.Contour;

public abstract class ContourTestsBase<TClient>: TestBase  where TClient : ContourBaseClient
{
    protected readonly ContourTestFactory Factory;
    protected readonly ContourMap ContourMap;

    protected  ContourTestsBase()
    {
        Factory = new ContourTestFactory();
        ContourMap = Factory.Services.GetRequiredService<IOptions<ContourMap>>().Value;
    }

    protected TClient OpenClient()
    {
        var scope = Factory.Services.CreateScope();
        return scope.ServiceProvider.GetRequiredService<TClient>();
    }

    protected virtual TRequest NewRequest<TRequest>() where TRequest : SpotRequest, new()
    {
        var map = ContourMap.Spots.First(a=>a.Options.Type == ChannelType.Ip);
        var request = new TRequest();
        request.Options = map.Options.DeepBurn<IpOptions>();
        request.Address = map.Addresses.First();
        return request;
    }

    protected virtual TRequest NewRequestComPort<TRequest>() where TRequest : SpotRequest, new()
    {
        var map = ContourMap.Spots.First(a=>a.Options.Type == ChannelType.ComPort);
        var request = new TRequest();
        request.Options = map.Options.DeepBurn<ComPortOptions>();
        request.Address = map.Addresses.First();
        return request;
    }

    protected virtual TRequest NewBaseRequest<TRequest>() where TRequest : RequestBase, new()
    {
        var request = new TRequest();
        return request;
    }
}
