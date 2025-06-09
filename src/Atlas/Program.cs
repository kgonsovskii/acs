using Microsoft.Extensions.Hosting;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public class Program : ProgramBase<Startup>
{
    public static void Main(string[] args)
    {
        new Program().Run(args);
    }

    protected override IHostBuilder CreateHostBuilder(string[] args)
    {
        var builder = base.CreateHostBuilder(args);
        return builder;
    }
}
