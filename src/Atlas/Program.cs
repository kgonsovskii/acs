using Microsoft.Extensions.Hosting;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public class Program : ProgramBase<Startup>
{
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
