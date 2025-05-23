using System.Net.Sockets;

namespace SevenSeals.Tss.Contour;


public class ClientManager: BaseManager<Client>
{
    private Client? _mainClient;

    public async Task AddAsync(Socket socket, string connectionInfo)
    {
        var client = new Client(connectionInfo);
        await client.OpenAsync(socket);
        Add(client);
    }

    public async Task DisconnectAsync()
    {

        foreach (var client in this)
        {
            await client.DisconnectAsync(true);
        }

        Clear();
    }

    public async Task CleanupAsync()
    {

        _clients.RemoveAll(c => !c.IsReady);
    }
}
