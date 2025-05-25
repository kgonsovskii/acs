using System.Reflection;

namespace SevenSeals.Tss.Shared;

public class Settings
{
    private readonly CommandLineArgs _commandLineArgs;
    public string[] Args => this._commandLineArgs.Args;

    public Settings(CommandLineArgs args)
    {
        _commandLineArgs = args;
    }

    public string RootDir =>
        Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)!;

    public string DataDir => Path.Combine(RootDir, "data");

}
