using System.Text.Json;
using Atlas.Component;
using JetBrains.Annotations;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Atlas;
using SevenSeals.Tss.Web.Api.Services;
using SevenSeals.Tss.Web.Api.JsonConverters;
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
        services.AddAtlasStorage();
        services.AddSingleton<IAtlasService, AtlasService>();
        services.AddScoped<IPlanGenerationService, PlanGenerationService>();
        return services;
    }

    protected override void ConfigureSwaggerInternal(SwaggerGenOptions opts)
    {
        //
    }

    protected override void ConfigureJsonInternal(JsonSerializerOptions opts)
    {
        opts.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
        opts.DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.Never;
        opts.WriteIndented = true;
        opts.IncludeFields = true;
        opts.Converters.Add(new System.Text.Json.Serialization.JsonStringEnumConverter());
        opts.Converters.Add(new ShapeJsonConverter());
    }

    protected override void UseInternal(IApplicationBuilder app, IWebHostEnvironment env, ILogger<Startup> logger)
    {
        app.UseCors();
        app.UseRouting();
        app.UseEndpoints(endpoints =>
        {
            endpoints.MapControllers();
        });
        app.UseStaticFiles(new StaticFileOptions
        {
            FileProvider = new PhysicalFileProvider(
                Path.Combine(Directory.GetCurrentDirectory(), "web")),
            RequestPath = ""
        });
    }
}
