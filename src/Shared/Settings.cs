using System.Reflection;
using Microsoft.Extensions.Configuration;

namespace SevenSeals.Tss.Shared;

public class Settings
{
    private readonly CommandLineArgs _commandLineArgs;
    public string[] Args => this._commandLineArgs.Args;

    public readonly int SpotPort;

    public string ConnectionString { get;}

    public Settings(CommandLineArgs args, IConfiguration configuration)
    {
        ConnectionString = configuration.GetConnectionString("Default")!;
        SpotPort = configuration.GetValue<int>("Spot:Port");
        _commandLineArgs = args;
    }

    public string RootDir =>
        Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)!;

    public string DataDir => Path.Combine(RootDir, "data");

}
