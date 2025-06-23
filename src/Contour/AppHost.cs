using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class AppHost : IHostedService
{
    private readonly EventQueue _eventQueue;

    private readonly IEventLogStorage _eventLog;

    private readonly ChannelHub _channels;

    private readonly ILogger<AppHost> _logger;
    private readonly Settings _settings;
    private readonly AppState _appState;
    private readonly ContourOptions _contourOptions;
    private readonly ContourHub _contourHub;
    private readonly ISpotStorage _spotStorage;

    public AppHost(Settings settings, ISpotStorage spotStorage, ContourHub contourHub, IOptions<ContourOptions> contourOptions,  AppState appState, EventQueue eventQueue, IEventLogStorage eventLog, ChannelHub channelHub,ILogger<AppHost> logger)
    {
        _appState = appState;
        _eventQueue = eventQueue;
        _eventLog = eventLog;
        _channels = channelHub;
        _logger = logger;
        _contourOptions = contourOptions.Value;
        _settings = settings;
        _spotStorage = spotStorage;
        _contourHub = contourHub;
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        _ = Task.Run( async () => await WorkerLoop(_appState.CancellationTokenSource.Token), _appState.CancellationTokenSource.Token);
        await Task.CompletedTask;
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        await _appState.CancellationTokenSource.CancelAsync();
    }

    private bool _initialized;

    private async Task Initialize()
    {
        if (_contourOptions.AutoPoll)
        {
            var spots = _spotStorage.GetAll().Where(a => a.IsActive).ToList();
            Parallel.ForEach(spots, async spot =>
            {
                foreach (var adr in spot.Addresses)
                {
                    var request = new ContourRequest()
                    {
                        SpotId = spot.Id,
                        Address = adr,
                        Options = spot.Options
                    };
                    try
                    {
                        await _contourHub.GetContour(request);
                    }
                    catch (Exception e)
                    {
                        _logger.LogCritical(e, "Can't activate spot: {CoName} with {CoId} ", spot.Name, spot.Id);
                    }
                }
            });
        }
    }

    private async Task WorkerLoop(CancellationToken ct)
    {
        if (!_initialized)
        {
            _initialized = true;
            await Initialize();
        }
        while (!ct.IsCancellationRequested)
        {
            try
            {
                await WorkerLoopIteration();
            }
            catch (Exception e)
            {
                _logger.LogError(e.Message);
            }
            await Task.Delay(_contourOptions.PollTimeout, ct);
        }
    }

    private async Task WorkerLoopIteration()
    {
        Parallel.ForEach(_contourHub, item =>
        {
            if (item.SuspendBefore >= DateTime.Now)
                return;
            try
            {
                item.Poll();
            }
            catch (Exception e)
            {
                item.SuspendBefore = DateTime.Now.Add(_contourOptions.DeadTimeout);
                _logger.LogCritical("Can't poll spot: {CoName} with {CoId} Delaying on {DeadTimeout}", item.Name,
                    item.Id, _contourOptions.DeadTimeout);
            }
        });
    }
}
