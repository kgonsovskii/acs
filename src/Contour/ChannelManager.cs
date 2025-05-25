namespace SevenSeals.Tss.Contour;


public class ChannelManager : BaseManager<string, Channel>
{
    private readonly Dictionary<string, Channel> _map = new();
    private readonly ChannelEvents _events;

    public ChannelManager(EventLog eventLog, EventQueue eventQueue)
    {
        _events = new ChannelEvents(eventLog, eventQueue);
    }

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
    protected override Channel CreateItem(string key)
    {
        throw new NotImplementedException();
    }
}
