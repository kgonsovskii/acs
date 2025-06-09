using System.Diagnostics;
using System.Net;
using System.Net.Sockets;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class IpChannel : Channel
{
    public new IpOptions ChannelOptions => base.ChannelOptions as IpOptions ?? throw new InvalidOperationException();
    private Socket _comm;

    public IpChannel(SpotOptions options, IpOptions ipOptions,CancellationToken cancellationToken) : base(options, ipOptions, cancellationToken)
    {
    }

    public override string Id => $"{ChannelOptions.Host}:{ChannelOptions.Port}";

    public override async Task Open()
    {
        _comm = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        var ipAddr = Dns.GetHostAddresses(ChannelOptions.Host)[0];
        var endpoint = new IPEndPoint(ipAddr, ChannelOptions.Port);
        await _comm.ConnectAsync(endpoint);
        _comm.NoDelay = true;
        _setReady(true);
    }

    public override string ConnInfo()
    {
        throw new NotImplementedException();
    }

    protected internal override int Read(byte[] buffer, int size)
    {
        Debug.Assert(size > 0);
        var bytesRead = 0;

            if (!_waitInput(Options.ResponseTimeout))
                return 0;
            bytesRead = _comm.Receive(buffer, 0, size, SocketFlags.None);

        return bytesRead;
    }

    protected internal override int Read(out byte buf)
    {
        var buffer = new byte[1];
        var result = Read(buffer, 0, buffer.Length);
        buf = buffer[0];
        return result;
    }

    protected internal override int Read(byte[] buf, int offset, int size)
    {
        Debug.Assert(size > 0);
        var bytesRead = 0;

        if (!_waitInput(Options.ResponseTimeout))
            return 0;
        bytesRead = _comm.Receive(buf, offset, size, SocketFlags.None);

        return bytesRead;
    }

    protected internal override void Write(byte[] buffer, int size)
    {
        Debug.Assert(size > 0);
        _chkReady();

        if (_error)
            _flushInput();
        _comm.Send(buffer, 0, size, SocketFlags.None);
    }

    protected internal override void Write(byte[] buf, int offset, int size)
    {
        Debug.Assert(size > 0);
        _chkReady();

        if (_error)
            _flushInput();
        _comm.Send(buf, offset, size, SocketFlags.None);
    }

    private bool _waitInput(TimeSpan timeout)
    {
        return _comm.Poll(timeout, SelectMode.SelectRead);
    }
}
