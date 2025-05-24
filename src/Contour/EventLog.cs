using SevenSeals.Tss.Contour.Events;
using SevenSeals.Tss.Shared;
using System;

namespace SevenSeals.Tss.Contour;

public class EventLog: Database
{
    private readonly ChannelManager _channelManager;
    private readonly EventQueue _eventQueue;

    public EventLog(ChannelManager channelManager, EventQueue eventQueue,  Settings settings): base(settings)
    {
        _channelManager = channelManager;
        _eventQueue = eventQueue;
    }

    protected override string Name => "EventLog.db";

    protected override void Initialize()
    {
        using var cmd = Connection.CreateCommand();
        cmd.CommandText = "CREATE TABLE IF NOT EXISTS EventLog(ch BLOB, t1 BLOB, t2 BLOB, addr BLOB, evt BLOB)";
        cmd.ExecuteNonQuery();
    }

    public void Add(LogEvent evt)
    {
        lock (Lock)
        {
            using var cmd = Connection.CreateCommand();
            cmd.CommandText = "INSERT INTO EventLog(@ch, @t1, @t2, @addr, @evt)";
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
        lock (Lock)
        {
            if (_channelManager.Any())
                throw new InvalidOperationException("Channels not empty");

            using var cmd = Connection.CreateCommand();
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
                _eventQueue.Push(evt);
                count++;
            }

            return count;
        }
    }

    public void Clear()
    {
        lock (Lock)
        {
            if (_channelManager.Any())
                throw new InvalidOperationException("Channels not empty");

            using var dropCmd = Connection.CreateCommand();
            dropCmd.CommandText = "DROP TABLE IF EXISTS EventLog";
            dropCmd.ExecuteNonQuery();

            using var vacuumCmd = Connection.CreateCommand();
            vacuumCmd.CommandText = "VACUUM";
            vacuumCmd.ExecuteNonQuery();
        }
    }
}

public class LogEvent
{
    public byte[] Ch { get; set; }
    public byte[] ControllerTimestamp { get; set; }
    public byte[] Timestamp { get; set; }
    public byte Addr { get; set; }
    public byte[] Data { get; set; }

    public LogEvent(byte[] ch, byte[] data, byte[] timestamp)
    {
        Ch = ch;
        Data = data;
        Timestamp = timestamp;
        Addr = 0;
        ControllerTimestamp = new byte[6];
    }
}

