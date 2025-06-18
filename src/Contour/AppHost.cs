using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Contour.Storage;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class AppHost : IHostedService
{
    private readonly EventQueue _eventQueue;

    private readonly IEventLogStorage _eventLog;

    private readonly ChannelHub _channels;

    private readonly SemaphoreSlim _semaphore = new(1, 1);
    private readonly SemaphoreSlim _taskSemaphore = new(1, 1);

    private readonly ILogger<AppHost> _logger;
    private readonly Settings _settings;
    private readonly AppState _appState;

    public AppHost(Settings settings, AppState appState, EventQueue eventQueue, IEventLogStorage eventLog, ChannelHub channelHub,ILogger<AppHost> logger)
    {
        _appState = appState;
        _eventQueue = eventQueue;
        _eventLog = eventLog;
        _channels = channelHub;
        _logger = logger;
        _settings = settings;
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        _ = Task.Run( async () => await WorkerLoop(_appState.CancellationTokenSource.Token), _appState.CancellationTokenSource.Token);
        await Task.CompletedTask;
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        await _appState.CancellationTokenSource.CancelAsync();
        await SwitchToAuto(true, true, true);
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

            await Task.Delay(100, ct);
        }
    }

    private async Task WorkerLoopIteration()
    {
        /*if (stopEventQueue)
        {
            await SwitchToAuto(true, false, false);
        }*/
    }

    private async Task SwitchToAuto(bool doTheBest, bool closeChannel, bool clearChannels)
    {
        var channelsChanged = false;
        await _semaphore.WaitAsync();
        try
        {
            foreach (var channel in _channels)
            {
                /*foreach (var controller in channel.Controllers)
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
                }*/
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
       //     _eventQueue.Push(new ChannelsChangedEvent());
        }
    }
}
