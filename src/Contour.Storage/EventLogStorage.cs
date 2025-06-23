using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public interface IEventLogStorage : IBaseStorage<EventLog, int>;

public class EventLogStorage : BaseStorage<EventLog, int>, IEventLogStorage
{

   // private readonly ChannelHub _channel;
   // private readonly EventQueue _eventQueue;

    public EventLogStorage(Settings settings, ILogger<EventLogStorage> logger): base(settings, logger)
    {
       // _channelManager = channelManager;
       // _eventQueue = eventQueue;
    }

    public bool IsLogging => true;

  /*  protected override void Initialize()
    {
        using var cmd = Connection.CreateCommand();
        cmd.CommandText = @"CREATE TABLE IF NOT EXISTS EventLog (
    ch BYTEA,
    t1 BYTEA,
    t2 BYTEA,
    addr BYTEA,
    evt BYTEA
);";
        cmd.ExecuteNonQuery();
    }

    public void Add(Event evt)
    {
        if (evt is LogEvent logEvent)
        {
            using var cmd = Connection.CreateCommand();
            cmd.CommandText = "INSERT INTO EventLog(@ch, @t1, @t2, @addr, @evt)";
            cmd.Parameters.AddWithValue("@ch", logEvent.Ch);
            cmd.Parameters.AddWithValue("@t1", logEvent.ControllerTimestamp);
            cmd.Parameters.AddWithValue("@t2", logEvent.Timestamp);
            cmd.Parameters.AddWithValue("@addr", new[] { logEvent.Addr });
            cmd.Parameters.AddWithValue("@evt", logEvent.Data);
            cmd.ExecuteNonQuery();
        }
    }

    public int Send(byte[] beg, byte[] end, int limit, int offset)
    {
        if (_channel.Any())
            throw new InvalidOperationException("Channels not empty");

        using var cmd = Connection.CreateCommand();
        cmd.CommandText = $"SELECT * FROM coevtlog WHERE t1>=@beg AND t1<=@end LIMIT {limit} OFFSET {offset}";
        cmd.Parameters.AddWithValue("@beg", beg);
        cmd.Parameters.AddWithValue("@end", end);

        var count = 0;
        using var reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            var evt = ContourEvent.Create(
                System.Text.Encoding.UTF8.GetString((byte[])reader["ch"]),
                (byte[])reader["evt"]
            );
            _eventQueue.Push(evt);
            count++;
        }

        return count;
    }

    public void Clear()
    {
        if (_channel.Any())
            throw new InvalidOperationException("Channels not empty");

        using var dropCmd = Connection.CreateCommand();
        dropCmd.CommandText = "DROP TABLE IF EXISTS EventLog";
        dropCmd.ExecuteNonQuery();
    }*/
} 