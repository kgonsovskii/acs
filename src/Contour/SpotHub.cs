using SevenSeals.Tss.Contour.Events;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class SpotHub : HubBase<string, Contour>
{
    private readonly AppState _state;
    public ChannelHub ChannelHub { get; }

    public SpotHub(ChannelHub channelHub, AppState appState)
    {
        _state = appState;
        ChannelHub = channelHub;
    }

    public class Evt
    {
        public DateTime DateTime { get; set; }
        public string message{ get; set; }
    }

    public List<Evt> Events { get; } = new List<Evt>();

    public void OnEvent(Contour contour, byte[] buf)
    {
        var ce = new ControllerEvent("123", buf);
        var msg = ce.Kind.ToString();
        var evt = new Evt()
        {
            DateTime = DateTime.UtcNow,
            message = msg,
        };
        Events.Insert(0, evt);
    }

    public async Task<Contour> GetSpot(SpotRequest request, bool force = false)
    {
        var channel = await ChannelHub.OpenChannel(request);
        var spot = new Contour(channel, _state.CancellationToken, request.AddressByte);
        if (Map.TryGetValue(spot.Id, out var value))
            spot = value; else Map.TryAdd(spot.Id, spot);
        spot.OnEvent = OnEvent;
        spot.Activate();
        return spot;
    }
}
