using SevenSeals.Tss.Contour.Events;

namespace SevenSeals.Tss.Contour;


using System;
using System.Collections.Concurrent;
using System.Threading;
using System.Threading.Tasks;

public class EventQueue : IDisposable
{
    private readonly SemaphoreSlim _sem = new(0);
    private readonly ConcurrentQueue<Event> _queue = new();
    private readonly CancellationTokenSource _cts = new();
    private readonly Task _senderTask;
    private bool _busy;
    private int _limit = int.MaxValue;
    private readonly object _lock = new();

    private readonly Settings _settings;
    private readonly ContourState _state;
    private readonly ClientManager _clientManager;
    private readonly Database _database;

    public EventQueue(Settings settings, ContourState state, Database database, ClientManager clientManager)
    {
        _database = database;
        _settings = settings;
        _state = state;
        _clientManager = clientManager;
        _senderTask = Task.Run(SenderLoopAsync);
    }

    public void Push(ControllerEvent evt)
    {
        lock (_lock)
        {
            _queue.Enqueue(evt);
            if (_queue.Count == 1)
                _sem.Release();
            else if (_queue.Count == _limit)
            {
                _queue.Enqueue(new QueueFullEvent());
                _state.DoTask(TaskEnum.StopEventCue);
            }
        }
    }

    public void SetLimit(int limit)
    {
        lock (_lock)
        {
            _limit = limit;
        }
    }

    public void Save()
    {
        lock (_lock)
        {
            if (_queue.IsEmpty) return;

            using var db = CreateDatabase();
            using var tx = db.BeginTransaction();
            foreach (var evt in _queue)
            {
                if (evt is ControllerEvent ce)
                {
                    using var cmd = db.CreateCommand();
                    cmd.CommandText = "INSERT INTO coevtcue (ch, t2, evt) VALUES (@ch, @t2, @evt)";
                    cmd.Parameters.AddWithValue("@ch", ce.Channel);
                    cmd.Parameters.AddWithValue("@t2", ce.Timestamp);
                    cmd.Parameters.AddWithValue("@evt", ce.Data);
                    cmd.ExecuteNonQuery();
                }
            }
            tx.Commit();
        }
    }

    public void Load()
    {
        lock (_lock)
        {
            using var db = CreateDatabase();
            using var cmd = db.CreateCommand();
            cmd.CommandText = "SELECT ch, t2, evt FROM coevtcue";
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                var evt = new ControllerEvent(reader.GetString(0), reader.GetDateTime(1), reader.GetBytes(2));
                evt.Used = true;
                _queue.Enqueue(evt);
            }
            Execute(db,"DROP TABLE IF EXISTS coevtcue");
            Execute(db,"VACUUM");
        }
    }

    public void Stop()
    {
        _cts.Cancel();
        _sem.Release();
    }

    public void Signal()
    {
        lock (_lock)
        {
            if (!_busy)
                _sem.Release();
        }
    }

    private async Task SenderLoopAsync()
    {
        while (!_cts.IsCancellationRequested)
        {
            await _sem.WaitAsync(_cts.Token);
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

    public void Dispose()
    {
        _cts.Cancel();
        _sem.Dispose();
        _cts.Dispose();
    }

}
