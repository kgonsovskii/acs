using Microsoft.Extensions.Hosting;

namespace SevenSeals.Tss.Shared;

public class Program : ProgramBase<Startup>
{
    protected override string ServiceGroup => "Db.Tool";

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
