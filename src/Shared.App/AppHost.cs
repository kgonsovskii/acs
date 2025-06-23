using Microsoft.Extensions.Hosting;
using Serilog;
using System.Collections.Concurrent;

namespace SevenSeals.Tss.Shared;

/// <summary>
/// Manages the application lifecycle and state
/// </summary>
public class AppHost
{
    private static readonly ConcurrentDictionary<Type, AppHost> _instances = new();
    private readonly CancellationTokenSource _shutdownTokenSource;
    private IHost? _host;
    private bool _isShuttingDown;
    private readonly Type _id;

    private AppHost(Type id)
    {
        _id = id;
        _shutdownTokenSource = new CancellationTokenSource();
    }

    public static AppHost GetOrCreate(Type type)
    {
        return _instances.GetOrAdd(type, _ => new AppHost(type));
    }

    public static void Remove(Type id)
    {
        _instances.TryRemove(id, out _);
    }

    public CancellationToken ShutdownToken => _shutdownTokenSource.Token;

    public void Initialize(IHost host)
    {
        if (_host != null)
            throw new InvalidOperationException("AppHost is already initialized");

        _host = host;
    }

    public async Task ShutdownAsync()
    {
        if (_isShuttingDown || _host == null)
            return;

        _isShuttingDown = true;

        try
        {
            Log.Information("Application {AppId} is shutting down...", _id);
            _shutdownTokenSource.Cancel();

            await _host.WaitForShutdownAsync();
            Remove(_id);

            Log.Information("Application {AppId} shutdown complete.", _id);
        }
        catch (Exception ex)
        {
            Log.Error(ex, "Error during application {AppId} shutdown", _id);
        }
        finally
        {
            _shutdownTokenSource.Dispose();
            _host?.Dispose();
            _host = null;
            Log.CloseAndFlush();
        }
    }

    public bool IsShuttingDown => _isShuttingDown;
}
