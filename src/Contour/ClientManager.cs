using System.Net.Sockets;
using SevenSeals.Tss.Contour.Events;

namespace SevenSeals.Tss.Contour;

public class ClientManager : IDisposable
{
    private readonly List<Client> _clients = new();
    private readonly object _sync = new();
    private Client? _mainClient;
    private readonly ClientEvents _events;

    public ClientManager()
    {
        _mainClient = null;
        _events = new ClientEvents();
    }

    public async Task CleanupAsync()
    {

    }

    public async Task DisconnectAsync()
    {

    }

    public void Dispose()
    {
    }

    public int Count
    {
        get
        {
            lock (_sync)
            {
                return _clients.Count;
            }
        }
    }

    public void Add(Socket socket, string name)
    {
        lock (_sync)
        {
            //var client = new Client(socket, name);
            //_clients.Add(client);
        }
    }

    public bool Exec(SendableEvent evt, bool forAll, bool noAck)
    {
        return true;
    }


    private void SwitchToAuto(bool a, bool b, bool c)
    {
        // implement as needed
    }
}

