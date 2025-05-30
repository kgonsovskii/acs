using System.Reflection;
using Microsoft.Extensions.Configuration;

namespace SevenSeals.Tss.Shared;

public class Settings
{
    private readonly CommandLineArgs _commandLineArgs;
    public string[] Args => _commandLineArgs.Args;

    public string ConnectionString { get;}

    public readonly bool IsDevelopment = true;

    public Settings(CommandLineArgs args, IConfiguration configuration)
    {
        ConnectionString = configuration.GetConnectionString("Default")!;
        IsDevelopment = true;

        _commandLineArgs = args;
    }

    public string RootDir =>
        Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)!;
}
