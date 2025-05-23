using System.Net.Sockets;

namespace SevenSeals.Tss.Contour;


public class Client
{
    public string ConnectionInfo { get; }
    public bool IsReady { get; private set; }

    public Client(string connectionInfo)
    {
        ConnectionInfo = connectionInfo;
    }

    public async Task OpenAsync(Socket socket)
    {
        IsReady = true;
        await Task.CompletedTask;
    }

    public async Task DisconnectAsync(bool force)
    {
        IsReady = false;
        await Task.CompletedTask;
    }
}
