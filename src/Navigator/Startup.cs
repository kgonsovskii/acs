using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace SevenSeals.Tss.Navigator;

public class Startup: SevenSeals.Tss.Shared.StartupBase<Startup>
{
    private readonly IConfiguration _configuration;
    public Startup(IConfiguration configuration) : base(configuration)
    {
        _configuration = configuration;
    }

    public override void ConfigureServices(IServiceCollection services)
    {
        base.ConfigureServices(services);
    }

    public override void Configure(IApplicationBuilder app, IWebHostEnvironment env, ILogger<Startup> logger)
    {
        //
        base.Configure(app, env, logger);
    }
}
