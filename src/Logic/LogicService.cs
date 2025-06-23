using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Actor;
using SevenSeals.Tss.Atlas;
using SevenSeals.Tss.Chronicle;
using SevenSeals.Tss.Codex;
using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Contour.Events;
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

    public Task OnContourEvent(List<ContourEvent> contourEvents);
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

    private readonly ClientEvents _clientEvents;

    private readonly ILogger<LogicService> _logger;

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
        IChronicleClient chronicleClient,
        ClientEvents clientEvents,
        ILogger<LogicService> logger )
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
        _clientEvents = clientEvents;
        _logger = logger;
    }

    /// <summary>
    /// Получены собыитие из Contour
    /// </summary>
    /// <returns></returns>
    public async Task OnContourEvent(List<ContourEvent> contourEvents)
    {
        foreach (var @event in contourEvents)
        {
            try
            {
                var spot = await SpotClient.GetById(@event.SpotId);
                switch (@event)
                {
                    case ContourKeyEvent keyEvent:
                        await OnKeyEvent(spot, keyEvent);
                        break;
                    case ContourDoorOpenEvent doorOpenEvent:
                        await OnDoorOpenEvent(spot, doorOpenEvent);
                        break;
                    case ContourDoorCloseEvent doorCloseEvent:
                        await OnDoorCloseEvent(spot, doorCloseEvent);
                        break;
                }
            }
            catch (Exception e)
            {
                _logger.LogError("Error handling event");
            }

        }
    }

    /// <summary>
    /// Событие приложения ключа
    /// </summary>
    private async Task OnKeyEvent(Spot spot, ContourKeyEvent @event)
    {
        var pass = await PassClient.GetByKeyNumber(@event.KeyNumber);

        if (pass.MemberId == null)
        {
            Return(null, "No member is linked by pass key");
            return;
        }

        switch (pass.Status)
        {
            case PassStatus.Deactivated:
                Return(null, "Pass is deactivated");
                return;
            case PassStatus.Expired:
                Return(null, "Pass is expired");
                return;
            case PassStatus.Lost:
                Return(null, "Pass is lost");
                return;
            case PassStatus.Stolen:
                Return(null, "Pass is stolen");
                return;
            case PassStatus.Active:
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }

        if (pass.Status != PassStatus.Active)
        {
            Return(null, "Pass is not active");
            return;
        }

        var member = await MemberClient.GetById((Guid)pass.MemberId);

        if (!member.IsActive)
        {
            Return(null, "Member is not active");
            return;
        }

        var relayOff = new RelayOffRequest()
        {
            RelayPort = 1,
            Address = @event.AddressAsString,
            Options = spot.Options
        };
        await ContourClient.RelayOff(relayOff);

        var relayOn = new RelayOnRequest()
        {
            RelayPort = 1,
            Address = @event.AddressAsString,
            Options = spot.Options
        };
        await ContourClient.RelayOn(relayOn);

        var cliEvent = new PassTouchedClientEvent()
        {
            AccessGranted = true,
            Member = member,
            Pass = pass,
            Reason = "Access Granted"
        };
        Return(cliEvent, cliEvent.Reason);
    }

    private void Return(PassTouchedClientEvent? clientEvent, string reason)
    {
        if (clientEvent == null)
        {
            clientEvent = new PassTouchedClientEvent()
            {
                AccessGranted = false,
                Reason = reason,
                Member = new Member(),
                Pass = new Pass(),
            };
        }
        _logger.LogInformation("PassTouchedClientEvent: {Reason}", reason);
        _clientEvents.Events.Add(clientEvent);
    }

    private async Task OnDoorOpenEvent(Spot spot, ContourDoorOpenEvent @event)
    {
        // not implemented
    }

    private async Task OnDoorCloseEvent(Spot spot, ContourDoorCloseEvent @event)
    {
        // not implemented
    }


    public Task StartAsync(CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }
}
