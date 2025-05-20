using System;
using System.Net;
using System.Net.Sockets;
using System.Text;

namespace Tss
{
    public static class Sock
    {
        public static void ConnectToServer(string serverIP, int port)
        {
            TcpClient client = new TcpClient();
            try
            {
                client.Connect(serverIP, port);
                Console.WriteLine($"Connected to server at {serverIP}:{port}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error connecting to server: {ex.Message}");
            }
        }
    }
} 