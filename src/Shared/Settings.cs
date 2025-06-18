using Microsoft.Extensions.Configuration;

namespace SevenSeals.Tss.Shared;

public class Settings
{
    public StorageType StorageType { get; set; }

    public SqlDialect SqlDialect { get; set; }

    private readonly CommandLineArgs _commandLineArgs;
    public string[] Args => _commandLineArgs.Args;

    public string ConnectionString { get;}

    public readonly bool IsDevelopment = true;

    public string Agent {get;set;}

    public string DataDir {get;set;}

    public Settings(CommandLineArgs args, IConfiguration configuration)
    {
        ConnectionString = configuration.GetConnectionString("Default")!;
        StorageType = configuration.GetSection("storageType").Get<StorageType>();
        SqlDialect = configuration.GetSection("sqlDialect").Get<SqlDialect>();
        var agent = configuration.GetValue<string>("Agent");
        Agent = MachineCode.GetMachineCode();
        if (agent != null)
            Agent += "-" + agent;
        _commandLineArgs = args;

        DataDir = GetDataDirectory();
        if (!Directory.Exists(DataDir))
            Directory.CreateDirectory(DataDir);
    }

    static string GetDataDirectory()
    {
        var envDir = Environment.GetEnvironmentVariable("ACS_DATA_DIR");
        if (!string.IsNullOrWhiteSpace(envDir))
            return Path.GetFullPath(envDir);

        string baseDir;

        if (OperatingSystem.IsWindows())
        {
            baseDir = Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData); // C:\ProgramData
        }
        else if (OperatingSystem.IsLinux() || OperatingSystem.IsMacOS())
        {
            baseDir = "/var/lib";
        }
        else
        {
            baseDir = Directory.GetCurrentDirectory();
        }

        return Path.Combine(baseDir, ".acs");
    }
}
