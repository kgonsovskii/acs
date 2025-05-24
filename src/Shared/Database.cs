using Microsoft.Data.Sqlite;
using SevenSeals.Tss.Contour;

namespace SevenSeals.Tss.Shared;

public abstract class Database
{
    protected readonly Settings Settings;
    protected Lock Lock { get; } = new();

    protected abstract string Name { get; }

    protected SqliteConnection Connection { get; }

    protected abstract void Initialize();

    protected Database(Settings settings)
    {
        Settings = settings;
        Connection = CreateDatabase();
    }

    private SqliteConnection CreateDatabase()
    {
        lock (Lock)
        {
            var path = Path.Combine(Settings.DataDir,Name);
            var conn = new SqliteConnection($"Data Source={path}");
            conn.Open();
            Initialize();
            return conn;
        }
    }

    protected void Execute(string cmdText)
    {
        using var cmd = Connection.CreateCommand();
        cmd.CommandText = cmdText;
        cmd.ExecuteNonQuery();
    }
}
