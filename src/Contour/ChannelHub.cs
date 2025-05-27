using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;


public class ChannelHub : HubBase<string, IpChannel>
{
    private readonly Dictionary<string, IpChannel> _map = new();
   // private readonly ChannelEvents _events;

   public async Task<IpChannel> OpenIpChannel(string host, int port)
   {
       var channel = new IpChannel(null, 1000, 1000, 1000, host, port);
       if (_map.ContainsKey(channel.Id))
           channel = Items[channel.Id];
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
