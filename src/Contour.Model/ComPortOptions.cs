using System.IO.Ports;
using Infra.Db;

namespace SevenSeals.Tss.Contour;

public class ComPortOptions: ChannelOptions
{
    public override ChannelType Type { get; set; } = ChannelType.ComPort;
    public string PortName { get; set; } = "COM1";
    public int BaudRate { get; set; } = 9600;

    [DbEnumTable(Schema = "contour")] public Parity Parity { get; set; } = Parity.None;
    public int DataBits { get; set; } = 8;
    [DbEnumTable(Schema = "contour")] public StopBits StopBits { get; set; } = StopBits.One;

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
