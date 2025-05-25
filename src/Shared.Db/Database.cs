using Microsoft.Data.Sqlite;

namespace SevenSeals.Tss.Shared;

public abstract class Database
{
    protected readonly Settings Settings;
    protected object Lock { get; } = new();

    protected abstract string Name { get; }

    protected SqliteConnection Connection { get; private set; }

    protected abstract void Initialize();

    protected Database(Settings settings)
    {
        Settings = settings;
        CreateDatabase();
    }

    private void CreateDatabase()
    {
        lock (Lock)
        {
            var path = Path.Combine(Settings.DataDir,Name);
            var dir = Path.GetDirectoryName(path)!;
            if (!Directory.Exists(dir))
                Directory.CreateDirectory(dir);
            Connection = new SqliteConnection($"Data Source={path}");
            Connection.Open();
            Initialize();
        }
    }

    protected void Execute(string cmdText)
    {
        using var cmd = Connection.CreateCommand();
        cmd.CommandText = cmdText;
        cmd.ExecuteNonQuery();
    }
}
