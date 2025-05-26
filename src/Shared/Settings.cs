using System.Reflection;
using Microsoft.Extensions.Configuration;

namespace SevenSeals.Tss.Shared;

public class Settings
{
    private readonly CommandLineArgs _commandLineArgs;
    public string[] Args => this._commandLineArgs.Args;

    public string ConnectionString { get;}

    public Settings(CommandLineArgs args, IConfiguration configuration)
    {
        ConnectionString = configuration.GetConnectionString("Default")!;
        _commandLineArgs = args;
    }

    public string RootDir =>
        Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)!;

    public string DataDir => Path.Combine(RootDir, "data");

}
