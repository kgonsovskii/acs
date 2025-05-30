using Npgsql;

namespace SevenSeals.Tss.Shared;

public abstract class Database
{
    protected readonly Settings Settings;
    protected NpgsqlConnection Connection { get; private set; }
    protected abstract void Initialize();

    protected Database(Settings settings)
    {
        Settings = settings;
        CreateDatabase();
    }

    private void CreateDatabase()
    {
        return;
        var adminConnectionString = new NpgsqlConnectionStringBuilder(Settings.ConnectionString)
        {
            Database = "postgres"
        }.ToString();

        using (var adminConnection = new NpgsqlConnection(adminConnectionString))
        {
            adminConnection.Open();

            using var checkCmd = new NpgsqlCommand("SELECT 1 FROM pg_database WHERE datname = @dbName", adminConnection);
            checkCmd.Parameters.AddWithValue("dbName", "acs");
            var exists = checkCmd.ExecuteScalar();

            if (exists == null)
            {
                using var createCmd = new NpgsqlCommand("CREATE DATABASE acs", adminConnection);
                createCmd.ExecuteNonQuery();
            }
        }

        Connection = new NpgsqlConnection(Settings.ConnectionString);
        Connection.Open();
        Initialize();
    }

    protected void Execute(string cmdText)
    {
        return;
        using var cmd = Connection.CreateCommand();
        cmd.CommandText = cmdText;
        cmd.ExecuteNonQuery();
    }
}

