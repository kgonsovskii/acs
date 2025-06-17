using System.Diagnostics.CodeAnalysis;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;
using Shared.Tests;

namespace SevenSeals.Tss.Contour;

[SuppressMessage("ReSharper", "MemberCanBePrivate.Global")]
public abstract class ContourTestsBase<TClient>: TestBase<TClient, ContourTestFactory, Startup> where TClient : IProtoClient
{
    protected readonly ContourMap ContourMap;

    protected ContourTestsBase()
    {
        ContourMap = Factory.Services.GetRequiredService<IOptions<ContourMap>>().Value;
    }

    protected new TRequest NewRequest<TRequest>() where TRequest : SpotRequest, new()
    {
        var map = ContourMap.Spots.First(a=>a.Options.Type == ChannelType.Ip);
        var request = new TRequest
        {
            Options = map.Options.DeepBurn<IpOptions>(),
            Address = map.Addresses.First()
        };
        return request;
    }

    protected virtual TRequest NewRequestComPort<TRequest>() where TRequest : SpotRequest, new()
    {
        var map = ContourMap.Spots.First(a=>a.Options.Type == ChannelType.ComPort);
        var request = new TRequest
        {
            Options = map.Options.DeepBurn<ComPortOptions>(),
            Address = map.Addresses.First()
        };
        return request;
    }

    protected virtual TRequest NewBaseRequest<TRequest>() where TRequest : IProtoRequest, new()
    {
        var request = new TRequest();
        return request;
    }
}
