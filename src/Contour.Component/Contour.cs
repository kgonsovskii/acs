namespace SevenSeals.Tss.Contour;

public partial class Contour: ProtoObject
{
    public Channel Channel { get; }
    public override string Id => $"{Channel.Id}-{Address}";
    public Byte Address { get; }


    private Task? _pollingTask;

    private bool? _isAlarm;

    private bool _polling;
    private bool _autonomic;

    private HashSet<ulong> _chipsActivated;
    private string _lastErrMsg;
    private Timer _aliveTimer;
    private Timer _deadTimer;
    private Timer _stateTimer;
    private int _recoverState;
    private int _state;

    private const int RecoverNone = 0;
    private const int RecoverAlive = 1;
    private const int RecoverDead = 2;

    private const int StateStateless = 1;
    private const int StateAutonomicPolling = 2;
    private const int StateComplex = 3;

    private readonly CancellationToken _cts = new CancellationToken();

    public Action<Contour, byte[]>? OnEvent { get; set; }

    public Contour(Channel channel, CancellationToken cancellationToken, byte addr)
    {
        _cts = cancellationToken;
         Channel = channel;
         Address = addr;
        _polling = false;
        _chipsActivated = new HashSet<ulong>();
        _recoverState = RecoverNone;
        _state = StateStateless;

        // Initialize timers
        _aliveTimer = new Timer(OnAliveTimer, null, Timeout.Infinite, Timeout.Infinite);
        _deadTimer = new Timer(OnDeadTimer, null, Timeout.Infinite, Timeout.Infinite);
        _stateTimer = new Timer(OnStateTimer, null, Timeout.Infinite, Timeout.Infinite);
    }

    protected void Polling()
    {
        while (_cts.IsCancellationRequested == false)
        {
            lock (Channel)
            {
                ReadEvt();
            }

            Thread.Sleep(999);
        }
    }

    public void Activate()
    {
        if (_pollingTask != null)
            return;
        if (!Channel.Options.AutoPoll)
            return;
        _pollingTask = Task.Run(Polling);
    }


    public string Name => $"Controller_{Address}";

    private void SetState(int state)
    {
        _state = state;
    }
}
