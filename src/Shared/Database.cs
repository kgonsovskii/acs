using Microsoft.Data.Sqlite;
using SevenSeals.Tss.Contour;

namespace SevenSeals.Tss.Shared;

public abstract class Database
{
    private readonly SqliteConnection _connection;
    private readonly Settings _settings;
    private readonly Lock _lock = new Lock();

    protected abstract string Name { get; }

    protected abstract void Initialize();

    public Database(Settings settings)
    {
        _settings = settings;
        _connection = CreateDatabase();
    }

    private SqliteConnection CreateDatabase()
    {
        var path = _settings.DataDir + Name;
        var conn = new SqliteConnection($"Data Source={Name}");
        conn.Open();
        Initialize();
        return conn;
    }

    public void Execute(string cmdText)
    {
        lock (_lock)
        {
            using var cmd = _connection.CreateCommand();
            cmd.CommandText = cmdText;
            cmd.ExecuteNonQuery();
        }
    }
}
