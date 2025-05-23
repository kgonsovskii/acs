namespace SevenSeals.Tss.Contour;

using System;
using Microsoft.Data.Sqlite;
using System.Diagnostics;

public class CoEvtLog
{
    private SqliteConnection _db;
    private volatile bool _log;
    private readonly object _sync = new object();

    private bool IsOpen => _db != null;

    public CoEvtLog()
    {
        _db = null;
        _log = false;
    }

    public void Open(bool log)
    {
        lock (_sync)
        {
            if (!IsOpen)
                OpenInternal();
            _log = log;
        }
    }

    public void Close()
    {
        lock (_sync)
        {
            try
            {
                if (IsOpen)
                    CloseInternal();
            }
            catch (Exception e)
            {
                HandleException(e);
            }
        }
    }

    private void OpenInternal()
    {
        string path = App.DataDir(); // Assuming `App` is accessible
        Directory.CreateDirectory(path);
        string filename = Path.Combine(path, "coevtlog.db");

        _db = new SQLiteConnection($"Data Source={filename};Version=3;");
        _db.Open();

        using var cmd = _db.CreateCommand();
        cmd.CommandText = "CREATE TABLE IF NOT EXISTS coevtlog(ch BLOB, t1 BLOB, t2 BLOB, addr BLOB, evt BLOB)";
        cmd.ExecuteNonQuery();
    }

    private void CloseInternal()
    {
        _db.Dispose();
        _db = null;
    }

    public void Add(ControllerEvent evt)
    {
        lock (_sync)
        {
            Debug.Assert(IsOpen);
            using var cmd = _db.CreateCommand();
            cmd.CommandText = "INSERT INTO coevtlog VALUES(@ch, @t1, @t2, @addr, @evt)";
            cmd.Parameters.AddWithValue("@ch", evt.Ch);
            cmd.Parameters.AddWithValue("@t1", evt.ControllerTimestamp);
            cmd.Parameters.AddWithValue("@t2", evt.Timestamp);
            cmd.Parameters.AddWithValue("@addr", new[] { evt.Addr });
            cmd.Parameters.AddWithValue("@evt", evt.Data);
            cmd.ExecuteNonQuery();
        }
    }

    public int Send(byte[] beg, byte[] end, int limit, int offset)
    {
        lock (_sync)
        {
            if (App.Channels.Count > 0)
                throw new InvalidOperationException("Channels not empty");

            using var scope = new ScopedOpen(this);

            using var cmd = _db.CreateCommand();
            cmd.CommandText = $"SELECT * FROM coevtlog WHERE t1>=@beg AND t1<=@end LIMIT {limit} OFFSET {offset}";
            cmd.Parameters.AddWithValue("@beg", beg);
            cmd.Parameters.AddWithValue("@end", end);

            int count = 0;
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                var evt = new ControllerEvent(
                    (byte[])reader["ch"],
                    (byte[])reader["evt"],
                    (byte[])reader["t2"]
                );
                App.EventCue.Enqueue(evt);
                count++;
            }

            return count;
        }
    }

    public void Clear()
    {
        lock (_sync)
        {
            if (App.Channels.Count > 0)
                throw new InvalidOperationException("Channels not empty");

            using var scope = new ScopedOpen(this);

            using var dropCmd = _db.CreateCommand();
            dropCmd.CommandText = "DROP TABLE IF EXISTS coevtlog";
            dropCmd.ExecuteNonQuery();

            using var vacuumCmd = _db.CreateCommand();
            vacuumCmd.CommandText = "VACUUM";
            vacuumCmd.ExecuteNonQuery();
        }
    }

    public bool IsLog => _log;

    private class ScopedOpen : IDisposable
    {
        private readonly CoEvtLog _log;
        private readonly bool _wasOpen;

        public ScopedOpen(CoEvtLog log)
        {
            _log = log;
            _wasOpen = log.IsOpen;
            if (!_wasOpen)
                log.OpenInternal();
        }

        public void Dispose()
        {
            if (!_wasOpen)
                _log.CloseInternal();
        }
    }

    private void HandleException(Exception e)
    {
        // Logging or rethrowing
        Console.WriteLine($"Exception: {e.Message}");
    }
}

// Placeholder classes for ControllerEvent and App
public class ControllerEvent
{
    public byte[] Ch { get; set; }
    public byte[] ControllerTimestamp { get; set; }
    public byte[] Timestamp { get; set; }
    public byte Addr { get; set; }
    public byte[] Data { get; set; }

    public ControllerEvent(byte[] ch, byte[] data, byte[] timestamp)
    {
        Ch = ch;
        Data = data;
        Timestamp = timestamp;
        Addr = 0; // example
        ControllerTimestamp = new byte[6]; // example
    }
}

public static class App
{
    public static string DataDir() => "./data/";
    public static List<object> Channels { get; } = new List<object>();
    public static Queue<ControllerEvent> EventCue { get; } = new Queue<ControllerEvent>();
}

