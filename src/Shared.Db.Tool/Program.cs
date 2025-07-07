using Microsoft.Extensions.Hosting;

namespace SevenSeals.Tss.Shared;

public class Program : ProgramBase<Startup>
{
    protected override string ServiceGroup => "Db.Tool";

    public static async Task Main(string[] args)
    {
        await new Program().Run(args);
    }

    protected override IHostBuilder CreateHostBuilder(string[] args)
    {
        var builder = base.CreateHostBuilder(args);
        return builder;
    }
}
