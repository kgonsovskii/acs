using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Logic;

public class AppHost : IHostedService
{
    private readonly ILogger<AppHost> _logger;
    private readonly Settings _settings;

    public AppHost(Settings settings, ILogger<AppHost> logger)
    {
        _settings = settings;
        _logger = logger;
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        _ = Task.Run(async () => await WorkerLoop(cancellationToken), cancellationToken);
        await Task.CompletedTask;
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        await Task.CompletedTask;
    }

    private async Task WorkerLoop(CancellationToken ct)
    {
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
            await Task.Delay(100, ct);
        }
    }

    private async Task WorkerLoopIteration()
    {
        await Task.CompletedTask;
    }
}
