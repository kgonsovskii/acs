using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Contour.Events;

namespace SevenSeals.Tss.Contour;

public class ContourHost : IHostedService
{
    private readonly CancellationTokenSource _cts;

    private EventQueue _eventQueue;

    private readonly ChannelManager _channels = new();

    private readonly ClientManager _clients = new();
    private readonly ControllerEventLogger _coEvtLog = new();
    private readonly SemaphoreSlim _semaphore = new(1, 1);
    private readonly SemaphoreSlim _taskSemaphore = new(1, 1);
    private bool _cleanupClients;
    private bool _stopEventQueue;
    private Task? _workerTask;

    private readonly ILogger<ContourHost> _logger;
    private readonly Settings _settings;

    public ContourHost(Settings settings, EventQueue eventQueue, ILogger<ContourHost> logger)
    {
        _eventQueue = eventQueue;
        _logger = logger;
        _settings = settings;
        _cts = new CancellationTokenSource();
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        _eventQueue.Load();
        _workerTask = Task.Run( async () => await WorkerLoop(_cts.Token), _cts.Token);
        await Task.CompletedTask;
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        await _cts.CancelAsync();
        await SwitchToAuto(true, true, true);
        _coEvtLog.Close();
        await _clients.DisconnectAsync();
        _eventQueue.Stop();
        _eventQueue.Save();
        await _cts.CancelAsync();
        if (_workerTask != null)
        {
            await _workerTask;
        }
    }



    private async Task WorkerLoop(CancellationToken ct)
    {
        while (!ct.IsCancellationRequested)
        {
            await _taskSemaphore.WaitAsync(ct);
            try
            {
                await WorkerLoopIteration();
            }
            catch (Exception e)
            {
                _logger.LogError(e.Message);
            }
            finally
            {
                _taskSemaphore.Release();
            }

            await Task.Delay(100, _cts.Token);
        }
    }

    private async Task WorkerLoopIteration()
    {
        var stopEventQueue = _stopEventQueue;
        _stopEventQueue = false;
        var cleanupClients = _cleanupClients;
        _cleanupClients = false;

        if (stopEventQueue)
        {
            await SwitchToAuto(true, false, false);
        }

        if (cleanupClients)
        {
            await _clients.CleanupAsync();
        }
    }

    private async Task SwitchToAuto(bool doTheBest, bool closeChannel, bool clearChannels)
    {
        var channelsChanged = false;
        await _semaphore.WaitAsync();
        try
        {
            foreach (var channel in _channels)
            {
                foreach (var controller in channel.Controllers)
                {
                    try
                    {
                        await controller.PollOffAsync(true);
                    }
                    catch (Exception ex)
                    {
                        if (doTheBest)
                        {
                            _logger.LogError(ex, "Error during poll off");
                        }
                        else
                        {
                            throw;
                        }
                    }
                }

                if (closeChannel)
                {
                    await channel.DeactivateAsync();
                }
            }

            if (clearChannels)
            {
                if (_channels.Count > 0)
                {
                    await _channels.ClearAsync();
                    channelsChanged = true;
                }
            }
        }
        finally
        {
            _semaphore.Release();
        }

        if (channelsChanged)
        {
            _eventQueue.Push(new ChannelsChangedEvent());
        }
    }

}
