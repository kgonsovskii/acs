using System.Diagnostics;
using System.Net;
using System.Net.Sockets;

namespace SevenSeals.Tss.Contour;

public class IpChannel : Channel
{
    public string Host { get; }
    public int Port { get; }

    private Socket _comm;

    public IpChannel(SpotOptions options, CancellationToken cancellationToken, string host, int port) : base(options, cancellationToken)
    {
        Host = host;
        Port = port;
    }

    public override string Id => $"{Host}:{Port}";

    public override async Task Open()
    {
        _comm = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        var ipAddr = Dns.GetHostAddresses(Host)[0];
        var endpoint = new IPEndPoint(ipAddr, Port);
        await _comm.ConnectAsync(endpoint);
        _comm.NoDelay = true;
        _setReady(true);
    }

    public override void Dispose()
    {
        _fini();
        base.Dispose();
    }

    public override string ConnInfo()
    {
        throw new NotImplementedException();
    }

    protected override void _init()
    {
        _comm = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        var ipAddr = Dns.GetHostAddresses(Host)[0];
        var endpoint = new IPEndPoint(ipAddr, Port);
        _comm.Connect(endpoint);
        _comm.NoDelay = true;
        _setReady(true);
    }

    protected override void _fini()
    {
        _setReady(false);
        _comm?.Close();
        _comm = null;
    }

    protected internal override int Read(byte[] buffer, int size)
    {
        Debug.Assert(size > 0);
        int bytesRead = 0;

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
        int bytesRead = 0;

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
