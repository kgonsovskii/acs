namespace SevenSeals.Tss.Contour;

public class Channels
{
    private readonly Dictionary<string, Channel> _channels = new Dictionary<string, Channel>();
    private readonly ChannelEvents _events = new ChannelEvents();
    private readonly object _sync = new object();

    public SerialChannel Add(ushort responseTimeout, ushort aliveTimeout, ushort deadTimeout, string devStr, uint speed)
    {
        lock (_sync)
        {
            var ch = new SerialChannel(_events, responseTimeout, aliveTimeout, deadTimeout, devStr, speed);
            _channels[ch.Id] = ch;
            return ch;
        }
    }

    public IpChannel Add(ushort responseTimeout, ushort aliveTimeout, ushort deadTimeout, string host, ushort port)
    {
        lock (_sync)
        {
            var ch = new IpChannel(_events, responseTimeout, aliveTimeout, deadTimeout, host, port);
            _channels[ch.Id] = ch;
            return ch;
        }
    }

    public Channel this[string id]
    {
        get
        {
            lock (_sync)
            {
                if (_channels.TryGetValue(id, out var channel))
                    return channel;
                throw new KeyNotFoundException($"Channel {id} not found");
            }
        }
    }

    public void Erase(string id)
    {
        lock (_sync)
        {
            _channels.Remove(id);
        }
    }

    public void Clear()
    {
        lock (_sync)
        {
            _channels.Clear();
        }
    }

    public int Count
    {
        get
        {
            lock (_sync)
            {
                return _channels.Count;
            }
        }
    }

    public bool IsEmpty
    {
        get
        {
            lock (_sync)
            {
                return _channels.Count == 0;
            }
        }
    }
}
