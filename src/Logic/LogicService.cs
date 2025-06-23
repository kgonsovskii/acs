using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Actor;
using SevenSeals.Tss.Atlas;
using SevenSeals.Tss.Chronicle;
using SevenSeals.Tss.Codex;
using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Logic.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Logic;

public interface ILogicService
{
    public Settings Settings { get; }
    public IMemberClient MemberClient { get; }
    public IPassClient PassClient { get; }
    public IAtlasClient AtlasClient { get; }
    public IZoneClient ZoneClient { get; }
    public ITransitClient TransitClient { get; }
    public ISpotClient SpotClient { get; }
    public IRouteClient RouteClient { get; }
    public ITimeZoneClient TimeZoneClient { get; }
    public IContourClient ContourClient { get; }
    public IChronicleClient ChronicleClient { get; }

    public Task<PassTouchedResponse> OnPassTouched(PassTouchedRequest request);
}
public class LogicService: ILogicService, IHostedService
{
    public Settings Settings { get; }
    public IMemberClient MemberClient { get; }
    public IPassClient PassClient { get; }
    public IAtlasClient AtlasClient { get; }
    public IZoneClient ZoneClient { get; }
    public ITransitClient TransitClient { get; }
    public ISpotClient SpotClient { get; }
    public IRouteClient RouteClient { get; }
    public ITimeZoneClient TimeZoneClient { get; }
    public IContourClient ContourClient { get; }
    public IChronicleClient ChronicleClient { get; }

    public LogicService(
        Settings settings,
        IMemberClient memberClient,
        IPassClient passClient,
        IAtlasClient atlasClient,
        IZoneClient zoneClient,
        ITransitClient transitClient,
        ISpotClient spotClient,
        IRouteClient routeClient,
        ITimeZoneClient timeZoneClient,
        IContourClient contourClient,
        IChronicleClient chronicleClient
    )
    {
        Settings = settings;
        MemberClient = memberClient;
        PassClient = passClient;
        AtlasClient = atlasClient;
        ZoneClient = zoneClient;
        TransitClient = transitClient;
        SpotClient = spotClient;
        RouteClient = routeClient;
        TimeZoneClient = timeZoneClient;
        ContourClient = contourClient;
        ChronicleClient = chronicleClient;
    }

    /// <summary>
    /// Событие приложения ключа
    /// </summary>
    /// <param name="args"></param>
    public async Task<PassTouchedResponse> OnPassTouched(PassTouchedRequest request)
    {
        var spot = await SpotClient.GetById(request.SpotId);

        var passes = await PassClient.GetAll();
        var members = await MemberClient.GetAll();

        var relayOff = new RelayOffRequest()
        {
            RelayPort = 1,
            Address = spot.Addresses.First(),
            Options = spot.Options
        };
        await ContourClient.RelayOff(relayOff);

        var relayOn = new RelayOnRequest()
        {
            RelayPort = 1,
            Address = spot.Addresses.First(),
            Options = spot.Options
        };
        await ContourClient.RelayOn(relayOn);
        var response = new PassTouchedResponse()
        {
            Member = members[0],
            Spot = spot,
            Pass = passes[0],
            Result = true
        };
        return response;
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {

    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {

    }
}
