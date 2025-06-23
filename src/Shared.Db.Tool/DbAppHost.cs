using Microsoft.Extensions.Hosting;

namespace SevenSeals.Tss.Shared;

public class DbAppHost: IHostedService
{
    private readonly DbTool _dbTool;
    public DbAppHost(DbTool dbTool)
    {
        _dbTool = dbTool;
    }
    public async Task StartAsync(CancellationToken cancellationToken)
    {
        await _dbTool.Generate([]);
        Environment.Exit(0);
    }

    public Task StopAsync(CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }
}
