using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Contour.Events;
using SevenSeals.Tss.Shared;
using System.Collections.Concurrent;

namespace SevenSeals.Tss.Contour;

public class ContourHub : HubBase<string, Contour>
{
    private readonly AppState _state;
    private ChannelHub ChannelHub { get; }

    public ContourHub(ChannelHub channelHub, AppState appState)
    {
        _state = appState;
        ChannelHub = channelHub;
    }

    private ConcurrentQueue<ControllerEvent> Events { get; } = new();

    private void OnContourEvent(object? sender, ControllerEvent evt)
    {
        Events.Enqueue(evt);
    }

    public List<ControllerEvent> GetEventsSnapshot()
    {
        return Events.ToList();
    }

    public void ClearEvents()
    {
        Events.Clear();
    }

    public async Task<Contour> GetContour(ContourRequest request)
    {
        var channel = await ChannelHub.OpenChannel(request);
        var contour = new Contour(channel, _state.CancellationToken, request.AddressByte);
        if (Map.TryGetValue(contour.Id, out var value))
        {
            contour = value;
        }
        else
        {
            Map.TryAdd(contour.Id, contour);
            contour.OnEvent += OnContourEvent;
            contour.Activate();
        }
        return contour;
    }
}
