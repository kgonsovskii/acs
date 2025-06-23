using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Gui.WinForms;

public abstract class GuiHost<TMainFrom> : IHostedService where TMainFrom : Form
{
    private readonly IServiceProvider _services;
    private readonly ILogger<GuiHost<TMainFrom>> _logger;
    private readonly IHostApplicationLifetime _applicationLifetime;
    private Task? _uiTask;
    private CancellationTokenSource? _uiCancellation;

    protected GuiHost(
        IServiceProvider services,
        ILogger<GuiHost<TMainFrom>> logger,
        IHostApplicationLifetime applicationLifetime)
    {
        _services = services;
        _logger = logger;
        _applicationLifetime = applicationLifetime;
    }

    public Task StartAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("Starting GUI application");

        _uiCancellation = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);

        _uiTask = Task.Run(() =>
        {
            try
            {
                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);

                using var scope = _services.CreateScope();
                var mainForm = scope.ServiceProvider.GetRequiredService<TMainFrom>();

                mainForm.FormClosed += (s, e) =>
                {
                    _logger.LogInformation("Main form closed, stopping application");
                    _applicationLifetime.StopApplication();
                };

                Application.Run(mainForm);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error running GUI application");
                _applicationLifetime.StopApplication();
                throw;
            }
        }, _uiCancellation.Token);

        return Task.CompletedTask;
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("Stopping GUI application");

        if (_uiTask != null)
        {
            await _uiCancellation?.CancelAsync()!;
            await Task.WhenAny(_uiTask, Task.Delay(5000, cancellationToken));
        }

        if (Application.MessageLoop)
        {
            Application.Exit();
        }
    }
}
