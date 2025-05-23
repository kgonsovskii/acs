using System.Net;
using System.Net.Sockets;

namespace SevenSeals.Tss.Contour;

public static class Rpc
{
    public static void StartServer(int port)
    {
        TcpListener server = new TcpListener(IPAddress.Any, port);
        server.Start();
        Console.WriteLine($"Server started on port {port}");

        while (true)
        {
            TcpClient client = server.AcceptTcpClient();
            Console.WriteLine("Client connected.");
            // Handle client connection
        }
    }
}