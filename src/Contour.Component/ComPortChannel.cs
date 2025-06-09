using System.Diagnostics;
using System.IO.Ports;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class ComPortChannel : Channel
{
    public new ComPortOptions ChannelOptions => base.ChannelOptions as ComPortOptions ?? throw new InvalidOperationException();

    private SerialPort _serialPort;

    public ComPortChannel(SpotOptions options, ComPortOptions comPortOptions, CancellationToken cancellationToken)
        : base(options, comPortOptions, cancellationToken)
    {
    }

    public override string Id => $"COM:{ChannelOptions.PortName}@{ChannelOptions.BaudRate}";

    public override async Task Open()
    {
        _serialPort = ChannelOptions.CreatePort();
        _serialPort.Open();
        _setReady(true);
    }

    public override void Dispose()
    {
        _serialPort?.Dispose();
        base.Dispose();
    }

    public override string ConnInfo()
    {
        return ChannelOptions.ToString();
    }

    protected internal override int Read(byte[] buffer, int size)
    {
        Debug.Assert(size > 0);
        try
        {
            return _serialPort.Read(buffer, 0, size);
        }
        catch (TimeoutException)
        {
            return 0;
        }
    }

    protected internal override int Read(out byte buf)
    {
        buf = 0;
        try
        {
            var read = _serialPort.ReadByte();
            if (read >= 0)
            {
                buf = (byte)read;
                return 1;
            }
        }
        catch (TimeoutException) { }
        return 0;
    }

    protected internal override int Read(byte[] buf, int offset, int size)
    {
        Debug.Assert(size > 0);
        try
        {
            return _serialPort.Read(buf, offset, size);
        }
        catch (TimeoutException)
        {
            return 0;
        }
    }

    protected internal override void Write(byte[] buffer, int size)
    {
        Debug.Assert(size > 0);
        _chkReady();
        if (_error) _flushInput();
        _serialPort.Write(buffer, 0, size);
    }

    protected internal override void Write(byte[] buf, int offset, int size)
    {
        Debug.Assert(size > 0);
        _chkReady();
        if (_error) _flushInput();
        _serialPort.Write(buf, offset, size);
    }
}
