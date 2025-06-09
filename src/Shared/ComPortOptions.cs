using System.IO.Ports;
using System.Text.Json.Serialization;

namespace SevenSeals.Tss.Shared;

public class ComPortOptions: ChannelOptions
{
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public override ChannelType Type { get; set; } = ChannelType.ComPort;
    public string PortName { get; set; } = "COM1";
    public int BaudRate { get; set; } = 9600;
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public Parity Parity { get; set; } = Parity.None;
    public int DataBits { get; set; } = 8;

    [JsonConverter(typeof(JsonStringEnumConverter))]
    public StopBits StopBits { get; set; } = StopBits.One;

    public int ReadTimeoutMs { get; set; } = 1000;
    public int WriteTimeoutMs { get; set; } = 1000;

    public SerialPort CreatePort()
    {
        var port = new SerialPort(PortName, BaudRate, Parity, DataBits, StopBits)
        {
            ReadTimeout = ReadTimeoutMs,
            WriteTimeout = WriteTimeoutMs
        };

        return port;
    }

    public override string ToString()
    {
        return $"Type={Type}, Port={PortName}";
    }
}
