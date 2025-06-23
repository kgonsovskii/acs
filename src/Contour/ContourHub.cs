using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Contour.Events;
using SevenSeals.Tss.Shared;
using System.Collections.Concurrent;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Logic;
using SevenSeals.Tss.Logic.Api;

namespace SevenSeals.Tss.Contour;

public class ContourHub : HubBase<string, Contour>
{
    private ChannelHub ChannelHub { get; }

    private  readonly ILogger<ContourHub> _logger;

    private readonly IServiceProvider _serviceProvider;

    private ISpotStorage _spotStorage;


    public ContourHub(ChannelHub channelHub, ISpotStorage spotStorage, IServiceProvider serviceProvider, ILogger<ContourHub> logger)
    {
        _logger = logger;
        _spotStorage = spotStorage;
        _serviceProvider = serviceProvider;
        ChannelHub = channelHub;
    }

    private ConcurrentQueue<ContourEvent> Events { get; } = new();

    private async Task OnContourEvent(Contour sender, ContourEvent evt)
    {
        var logMessage = $"ContourEvent: {evt.Kind} Controller: {evt.ChannelId}, Address: {evt.Address}, Time: {evt.ControllerTimestamp}";

        if (evt is ContourKeyEvent keyEvent)
        {
            logMessage += $", Key: {keyEvent.KeyNumber}";
        }

        _logger.LogInformation(logMessage);

        if (sender.SpotId !=null && sender.SpotId != Guid.Empty)
            evt.SpotId = (Guid)sender.SpotId;
        evt.Address = sender.Address;
        Events.Enqueue(evt);

        using var scope = _serviceProvider.CreateScope();
        var logicClient = scope.ServiceProvider.GetRequiredService<ILogicCallbackClient>();
        try
        {
            var events = GetEventsSnapshot();
            ClearEvents();
            await logicClient.OnContourCallBack(new CallBackRequest()
            {
                ContourSnapshot = new ContourSnapshot()
                {
                    Events = events
                }
            });
        }
        catch (Exception e)
        {
            _logger.LogError("Error calling OnContourEvent for Logic");
        }
    }

    public List<ContourEvent> GetEventsSnapshot()
    {
        var pop = Events.ToList();
        return pop;
    }

    public void ClearEvents()
    {
        Events.Clear();
    }

    public async Task<Contour> GetContour(ContourRequest request)
    {
        var channel = await ChannelHub.OpenChannel(request, true);
        var contour = new Contour(request.SpotId, channel, request.AddressByte);
        if (Map.TryGetValue(contour.Id, out var value))
        {
            contour = value;
        }
        else
        {
            Map.TryAdd(contour.Id, contour);
            contour.OnEvent += OnContourEvent;
        }
        return contour;
    }
}
