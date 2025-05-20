using System;
using System.IO.Ports;

namespace Tss
{
    public static class SerialPort
    {
        public static void OpenPort(string portName, int baudRate)
        {
            SerialPort port = new SerialPort(portName, baudRate);
            try
            {
                port.Open();
                Console.WriteLine($"Port {portName} opened successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error opening port: {ex.Message}");
            }
        }
    }
} 