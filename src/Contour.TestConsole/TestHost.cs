using Microsoft.Extensions.Hosting;

namespace Contour.TestConsole;

public class TestHost: IHostedService
{
    private readonly TestTool _testTool;
    public TestHost(TestTool testTool)
    {
        _testTool = testTool;
    }
    public async Task StartAsync(CancellationToken cancellationToken)
    {
        await _testTool.StartPolling();
    }

    public Task StopAsync(CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }
}
