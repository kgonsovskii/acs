using Microsoft.Extensions.Hosting;
using SevenSeals.Tss.Contour.Events;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;


using System;
using System.Collections.Concurrent;
using System.Threading;
using System.Threading.Tasks;

public class EventQueue : Database, IHostedService, IDisposable
{
    private readonly ConcurrentQueue<Event> _queue = new();
    private readonly CancellationTokenSource _cts = new();

    private int _limit = int.MaxValue;

    private readonly AppState _state;
    private readonly ClientManager _clientManager;

    protected override string Name => "ControllerEventQueue.db";

    public EventQueue(Settings settings, AppState state, ClientManager clientManager): base(settings)
    {
        _state = state;
        _clientManager = clientManager;
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        Load();
        _ = Task.Run(SenderLoopAsync, cancellationToken);
        await Task.CompletedTask;
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        Save();
        await _cts.CancelAsync();
    }


    public void Dispose()
    {
        _cts.Dispose();
    }

    protected override void Initialize()
    {
        Execute("CREATE TABLE IF NOT EXISTS ControllerEventQueue(ch,t2,evt)");
    }

    public void Push(ControllerEvent evt)
    {
        lock (Lock)
        {
            _queue.Enqueue(evt);
            if (_queue.Count == _limit)
            {
                _queue.Enqueue(new QueueFullEvent());
                _state.DoTask(TaskEnum.StopEventCue);
            }
        }
    }

    public void SetLimit(int limit)
    {
        lock (Lock)
        {
            _limit = limit;
        }
    }

    private void Save()
    {
        lock (Lock)
        {
            if (_queue.IsEmpty) return;

            using var tx = Connection.BeginTransaction();
            foreach (var evt in _queue)
            {
                if (evt is ControllerEvent ce)
                {
                    using var cmd = Connection.CreateCommand();
                    cmd.CommandText = "INSERT INTO ControllerEventQueue (ch, t2, evt) VALUES (@ch, @t2, @evt)";
                    cmd.Parameters.AddWithValue("@ch", ce.ChannelId);
                    cmd.Parameters.AddWithValue("@t2", ce.Timestamp);
                    cmd.Parameters.AddWithValue("@evt", ce.Data);
                    cmd.ExecuteNonQuery();
                }
            }
            tx.Commit();
        }
    }

    private void Load()
    {
        lock (Lock)
        {
            using var cmd = Connection.CreateCommand();
            cmd.CommandText = "SELECT ch, t2, evt FROM ControllerEventQueue";
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                var evt = new ControllerEvent(reader.GetString(0), reader.GetDateTime(1), reader.GetBytes(2));
                evt.Used = true;
                _queue.Enqueue(evt);
            }
            Execute("DROP TABLE IF EXISTS ControllerEventQueue");
            Execute("VACUUM");
        }
    }


    private async Task SenderLoopAsync()
    {
        while (!_cts.IsCancellationRequested)
        {
            while (_queue.TryPeek(out var evt))
            {
                bool sent = _clientManager.Exec(evt);
                if (sent)
                    _queue.TryDequeue(out _);
                else
                    break;
            }
        }
    }
}
