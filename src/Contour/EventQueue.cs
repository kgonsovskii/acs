using System.Collections.Concurrent;
using Microsoft.Extensions.Hosting;
using SevenSeals.Tss.Contour.Events;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class EventQueue : IHostedService, IDisposable
{
    private readonly ConcurrentQueue<Event> _queue = new();
    private readonly CancellationTokenSource _cts = new();

    private int _limit = int.MaxValue;

    private readonly AppState _state;

    private readonly object _lock = new();

    public EventQueue(Settings settings, AppState state): base()
    {
        _state = state;
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {
      //  Load();
       // _ = Task.Run(SenderLoopAsync, cancellationToken);
        await Task.CompletedTask;
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
     //   Save();
        await _cts.CancelAsync();
    }


    public void Dispose()
    {
        _cts.Dispose();
    }

/*    protected override void Initialize()
    {
       /* Execute(@"

CREATE TABLE IF NOT EXISTS ContourEventQueue (
    ch TEXT,
    t2 TIMESTAMP,
    evt TEXT

);");*/
    }
/*
    public void Push(Event evt)
    {
        lock (_lock)
        {
            _queue.Enqueue(evt);
            if (_queue.Count == _limit)
            {
                _queue.Enqueue(new QueueFullEvent());
            //    _state.DoTask(TaskEnum.StopEventCue);
            }
        }
    }

    public void Pop(Event evt)
    {
        lock (_lock)
        {
            if (!_queue.IsEmpty)
                _queue.TryPeek(out var result);
        }
    }

    public void SetLimit(int limit)
    {
        lock (_lock)
        {
            _limit = limit;
        }
    }

    private void Save()
    {
    /*    lock (_lock)
        {
            if (_queue.IsEmpty) return;

            using var tx = Connection.BeginTransaction();
            foreach (var evt in _queue)
            {
                if (evt is ContourEvent ce)
                {
                    using var cmd = Connection.CreateCommand();
                    cmd.CommandText = "INSERT INTO ContourEventQueue (ch, t2, evt) VALUES (@ch, @t2, @evt)";
                    cmd.Parameters.AddWithValue("@ch", ce.ChannelId);
                    cmd.Parameters.AddWithValue("@t2", ce.Timestamp);
                    cmd.Parameters.AddWithValue("@evt", ce.Data);
                    cmd.ExecuteNonQuery();
                }
            }
            tx.Commit();
        }*/
/*   }

    private void Load()
    {
     /*   lock (_lock)
        {
            using var cmd = Connection.CreateCommand();
            cmd.CommandText = "SELECT ch, t2, evt FROM ContourEventQueue";
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                var bytes = new byte[20];
                reader.GetBytes(2,0, bytes, 0,10);
                var evt = ContourEvent.Create(reader.GetString(0), bytes, reader.GetDateTime(1));
                evt.Used = true;
                _queue.Enqueue(evt);
            }
            Execute("DROP TABLE IF EXISTS ContourEventQueue");
            Execute("VACUUM");
        }*/
/*    }


    private async Task SenderLoopAsync()
    {
        while (!_cts.IsCancellationRequested)
        {
            while (_queue.TryPeek(out var evt))
            {
                // bool sent = _clientManager.Exec(evt);
                // if (sent)
                //     _queue.TryDequeue(out _);
                // else
                //     break;
            }
        }
    }

    public Event? Front(out bool forAll, out bool coEvt)
    {
        lock (_lock)
        {
            forAll = false;
            coEvt = false;

            if (_queue.TryPeek(out var evt))
            {
                // Check if the event is sendable
                if (!SendableEventFactory.IsSendable(evt))
                {
                    return null;
                }

                if (evt.Type == EventType.Controller)
                {
                    coEvt = true;
                    if (evt is ContourEvent ce)
                    {
                        forAll = !ce.Used;
                        ce.Used = true;
                    }
                }
                else
                {
                    forAll = true;
                    coEvt = false;
                }

                return evt;
            }
        }

        return null;
    }*/
