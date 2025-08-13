using System.Text.Json;
using JetBrains.Annotations;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Logging;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace SevenSeals.Tss.Web.Api;

[UsedImplicitly]
public class Startup: Shared.StartupBase<Startup>
{
    protected override string ServiceGroup => "Web.Api";

    public Startup(IConfiguration configuration) : base(configuration)
    {
    }

    protected override IServiceCollection ConfigureServicesInternal(IServiceCollection services)
    {
        services.AddCors(options =>
        {
            options.AddDefaultPolicy(builder =>
            {
                builder.AllowAnyOrigin()
                       .AllowAnyHeader()
                       .AllowAnyMethod();
            });
        });
        return services;
    }

    protected override void ConfigureSwaggerInternal(SwaggerGenOptions opts)
    {
        //
    }

    protected override void ConfigureJsonInternal(JsonSerializerOptions opts)
    {
        //
    }

    protected override void UseInternal(IApplicationBuilder app, IWebHostEnvironment env, ILogger<Startup> logger)
    {
        // Serve static files from src/Web (one level up from Web.Api)
        app.UseStaticFiles(new StaticFileOptions
        {
            FileProvider = new PhysicalFileProvider(
                Path.Combine(Directory.GetCurrentDirectory(), "web")),
            RequestPath = ""
        });
        app.UseCors();
    }
}
