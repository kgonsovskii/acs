using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.Extensions.DependencyInjection;

namespace SevenSeals.Tss.Shared;

public static class Services
{
    internal static JsonSerializerOptions? JsonSerializerOptions;
    public static IServiceCollection ConfigureShared(this IServiceCollection services)
    {
        if (JsonSerializerOptions == null)
        {
            JsonSerializerOptions = new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
                WriteIndented = true
            };
            JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter(JsonNamingPolicy.CamelCase));
        }
        services.AddSingleton(JsonSerializerOptions);
        return services;
    }

    public static JsonSerializerOptions ConfigureJson(this JsonSerializerOptions jsonSerializerOptions)
    {
        jsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
        jsonSerializerOptions.WriteIndented = true;
        jsonSerializerOptions.Converters.Add(new JsonStringEnumConverter(JsonNamingPolicy.CamelCase));

        return jsonSerializerOptions;
    }
}
