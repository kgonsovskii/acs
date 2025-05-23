using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class Settings
{
    private readonly CommandLineArgs _commandLineArgs;
    public string[] Args => this._commandLineArgs.Args;

    public Settings(CommandLineArgs args)
    {
        _commandLineArgs = args;
    }

    public string RootDir => Path.Combine(Path.GetDirectoryName(Args[0]) ?? ".", "..");

    public string DataDir => Path.Combine(RootDir, "data");

}
