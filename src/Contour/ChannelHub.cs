using Microsoft.Extensions.Options;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;


public class ChannelHub : HubBase<string, Channel>
{
    private readonly SpotOptions _options;
    private readonly AppState _appState;
    public ChannelHub(IOptions<SpotOptions> settings, AppState state)
    {
        _options = settings.Value;
        _appState = state;
    }

    public async Task<Channel> OpenChannel(SpotRequest request)
    {
        Channel channel;
        if (request.Options.Type == ChannelType.ComPort)
        {
            channel = new ComPortChannel(_options, request.AsComPortOptions(), _appState.CancellationToken);
        }
        else
        {
            channel = new IpChannel(_options, request.AsIpOptions(), _appState.CancellationToken);
        }

        if (Map.TryGetValue(channel.Id, out var value))
            channel = value;
        else
            Map.TryAdd(channel.Id, channel);

        await channel.Open();
        return channel;
    }


    public ChannelHub()
    {
       // _events = new ChannelEvents(eventLog, eventQueue);
    }
/*
    public SerialChannel AddSerial(ushort responseTimeout, ushort aliveTimeout, ushort deadTimeout, string device, uint speed)
    {
        var ch = new SerialChannel(_events, responseTimeout, aliveTimeout, deadTimeout, device, speed);
        _map[ch.Id] = ch;
        return ch;
    }

    public IpChannel AddIP(ushort responseTimeout, ushort aliveTimeout, ushort deadTimeout, string host, ushort port)
    {
        var ch = new IpChannel(_events, responseTimeout, aliveTimeout, deadTimeout, host, port);
        _map[ch.Id] = ch;
        return ch;
    }

#if TSS_DAVINCI
    public DVRS422Channel AddDVRS422(ushort responseTimeout, ushort aliveTimeout, ushort deadTimeout, ushort speed)
    {
        var ch = new DVRS422Channel(_events, responseTimeout, aliveTimeout, deadTimeout, speed);
        _map[ch.Id] = ch;
        return ch;
    }
#endif

    protected string KeyToStr(string key)
    {
        return $"Channel<{key}>";
    }

    public bool TryGet(string id, out Channel? channel) => _map.TryGetValue(id, out channel);
*/
}
