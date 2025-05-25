using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Contour.Events;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class AppHost : IHostedService
{
    private readonly CancellationTokenSource _cts;

    private readonly EventQueue _eventQueue;

    private readonly EventLog _eventLog;

    private readonly ChannelManager _channels;

    private readonly ClientManager _clients;

    private readonly SemaphoreSlim _semaphore = new(1, 1);
    private readonly SemaphoreSlim _taskSemaphore = new(1, 1);
    private bool _cleanupClients;
    private bool _stopEventQueue;

    private readonly ILogger<AppHost> _logger;
    private readonly Settings _settings;

    public AppHost(Settings settings, EventQueue eventQueue, EventLog eventLog, ChannelManager channelManager, ClientManager clientManager, ILogger<AppHost> logger)
    {
        _eventQueue = eventQueue;
        _eventLog = eventLog;
        _channels = channelManager;
        _clients = clientManager;
        _logger = logger;
        _settings = settings;
        _cts = new CancellationTokenSource();
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        _ = Task.Run( async () => await WorkerLoop(_cts.Token), _cts.Token);
        await Task.CompletedTask;
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        await _cts.CancelAsync();
        await SwitchToAuto(true, true, true);
        await _clients.DisconnectAsync();
        await _cts.CancelAsync();
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
                    channel.Deactivate();
                }
            }

            if (clearChannels)
            {
                if (_channels.Any())
                {
                     _channels.Clear();
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
