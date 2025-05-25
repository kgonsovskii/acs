namespace SevenSeals.Tss.Contour;

using System;
using System.Collections.Generic;
using System.Threading;

public abstract class Channel: IDisposable
{
    public readonly IChannelEvents? events;
    public readonly ushort responseTimeout;
    public readonly ushort aliveTimeout;
    public readonly ushort deadTimeout;

    protected ControllerManager controllers = new ControllerManager();
    protected Thread _thread;
    protected bool _ready = false;
    protected volatile bool _deactivating = false;
    protected bool _error = false;
    protected volatile bool _extCmd = false;
    protected SynchronizationLock _sync = new SynchronizationLock();

    protected SpeedTimer _speedTimer;
    protected Trigger _fireSpeedEvent = new Trigger();
    protected bool _speedZeroFired = false;
    protected char _lastEvtCo;
    protected uint _speedOld, _speedCounter, _speedClock;

    protected Timer _timer = new Timer(_ => { });

    protected IDisposable _writeAllKeysTh;

    protected Channel(IChannelEvents? events, ushort responseTimeout, ushort aliveTimeout, ushort deadTimeout)
    {
        this.events = events;
        this.responseTimeout = responseTimeout;
        this.aliveTimeout = aliveTimeout;
        this.deadTimeout = deadTimeout;
        this._speedTimer = new SpeedTimer(this);
    }

    public virtual void Dispose()
    {
        GC.SuppressFinalize(this);
    }

    public abstract string Id { get; }
    public abstract string ConnInfo();

    public List<char> FindControllers()
    {
        // Stubbed logic
        return new List<char>();
    }

    public ControllerManager Controllers => new ControllerManager();

    public void Activate()
    {
        _init();
        _thread = new Thread(_work);
        _thread.Start();
    }

    public void Deactivate()
    {
        _deactivating = true;
        _fini();
        _thread?.Join();
        _thread = null;
    }

    public bool Active => _thread != null;
    public bool Ready => _ready;
    public (bool Active, bool Ready) ActiveAndReady => (Active, Ready);
    public uint PollSpeed => _speedOld;

    protected abstract void _init();
    protected abstract void _fini();
    protected abstract int _read(byte[] buf, int size);
    protected abstract void _write(byte[] buf, int size);

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

    protected void _work()
    {
        // Placeholder thread logic
        while (!_deactivating)
        {
            Thread.Sleep(100);
            // Simulated work
        }
    }

    protected bool _processController(Controller controller)
    {
        // Stubbed logic
        return true;
    }

    protected void _chkAndSetAliveTimer(Controller controller)
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
        private readonly object _lock = new object();

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
