using Infra;
using Microsoft.Extensions.DependencyInjection;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Shared;
using SevenSeals.Tss.Shared.Tests.Base;

namespace SevenSeals.Tss.Contour;

public abstract class ContourTestsBase<TClient>: TestBase<TClient, ContourTestFactory, Startup> where TClient : IProtoClient
{
    private readonly IList<Spot> _spots;

    protected ContourTestsBase()
    {
        var settings = Factory.Services.GetRequiredService<Settings>();
        settings.DataDir = ".\\";
        settings.StorageType = StorageType.Json;
        var storage = Factory.Services.GetRequiredService<ISpotStorage>();
        var map = storage.GetAll();
        _spots = map.ToList();
    }

    protected new TRequest NewRequest<TRequest>() where TRequest : ContourRequest, new()
    {
        var map = _spots.First(a=>a.Options.Type == ChannelType.Ip);
        var request = new TRequest
        {
            Options = map.Options.DeepBurn<IpOptions>(),
            Address = map.Addresses.First()
        };
        return request;
    }

    protected virtual TRequest NewRequestComPort<TRequest>() where TRequest : ContourRequest, new()
    {
        var map = _spots.First(a=>a.Options.Type == ChannelType.ComPort);
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
