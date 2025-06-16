namespace SevenSeals.Tss.Contour;

public abstract class Channel: ProtoObject, IDisposable
{
    public readonly IChannelEvents? events;

    public readonly SpotOptions Options;
    public ChannelOptions ChannelOptions { get;  }

    private readonly CancellationToken _cts;

  //  protected ControllerManager controllers = new ControllerManager();
    protected Thread _thread;
    protected bool _ready = false;
    protected volatile bool _deactivating = false;
    protected bool _error = false;
    protected volatile bool _extCmd = false;
    protected SynchronizationLock _sync = new();

    protected SpeedTimer _speedTimer;
    protected Trigger _fireSpeedEvent = new();
    protected bool _speedZeroFired = false;
    protected char _lastEvtCo;
    protected uint _speedOld, _speedCounter, _speedClock;

    protected Timer _timer = new(_ => { });

    protected IDisposable _writeAllKeysTh;

    protected Channel(SpotOptions options, ChannelOptions channelOptions,  CancellationToken cancellationToken)
    {
        Options = options;
        ChannelOptions = channelOptions;
        _cts = cancellationToken;
        _speedTimer = new SpeedTimer(this);
    }

    public bool IsPolling { get; set; }

    public abstract Task Open();


    public virtual void Dispose()
    {
        GC.SuppressFinalize(this);
    }


    public abstract string ConnInfo();

    public List<char> FindControllers()
    {
        // Stubbed logic
        return new List<char>();
    }

    //public ControllerManager Controllers => new ControllerManager();

    public void Activate()
    {
        if (IsPolling)
            return;


    }



    public void Deactivate()
    {
        _deactivating = true;
        _thread?.Join();
        _thread = null;
    }

    public bool Active => _thread != null;
    public bool IsReady => true;
    public (bool Active, bool Ready) ActiveAndReady => (true, true);
    public uint PollSpeed => _speedOld;


    protected internal abstract int Read(byte[] buf, int size);
    protected internal abstract int Read(out byte buf);

    protected internal abstract int Read(byte[] buf, int offset, int size);
    protected internal abstract void Write(byte[] buf, int size);
    protected internal abstract void Write(byte[] buf, int offset,  int size);

    protected internal void Write(byte[] buf) => Write(buf, buf.Length);

    protected void _flushInput()
    {
        // Implement flushing logic if needed
    }

    protected void _chkReady()
    {
        if (!_ready)
            throw new InvalidOperationException("Channel not ready");
    }

    protected void _setReady(bool val) => _ready = val;

    protected void _throwReading(string msg) => throw new ChannelException(this, "Reading", msg);
    protected void _throwWriting(string msg) => throw new ChannelException(this, "Writing", msg);

    protected void _initSpeed()
    {
        _speedOld = _speedCounter = _speedClock = 0;
        _speedZeroFired = false;
    }


    protected bool _processController(Contour contour)
    {
        // Stubbed logic
        return true;
    }

    protected void _chkAndSetAliveTimer(Contour contour)
    {
        // Stubbed logic
    }

    public class ExtCmdScopedLock : IDisposable
    {
        private readonly Channel _channel;

        public ExtCmdScopedLock(Channel channel)
        {
            _channel = channel;
            _channel._extCmd = true;
            _channel._sync.Lock();
        }

        public void Dispose()
        {
            _channel._extCmd = false;
            _channel._sync.Unlock();
        }
    }

    protected class SpeedTimer
    {
        private readonly Channel ch;

        public SpeedTimer(Channel ch)
        {
            this.ch = ch;
        }

        public void OnTimer()
        {
            ch._fireSpeedEvent.Set(true);
        }
    }

    protected class SynchronizationLock
    {
        private readonly object _lock = new();

        public void Lock() => Monitor.Enter(_lock);
        public void Unlock() => Monitor.Exit(_lock);
    }

    protected class Trigger
    {
        private volatile bool _flag = false;

        public void Set(bool value) => _flag = value;
        public bool Get() => _flag;
    }
}
