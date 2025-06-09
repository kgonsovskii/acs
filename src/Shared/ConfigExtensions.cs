using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace SevenSeals.Tss.Shared;

public static class ConfigurationExtensions
{
    public static IServiceCollection AddExtendedOptions<T>(
        this IServiceCollection services,
        string sectionName
    ) where T : class, new()
    {
        var json = File.ReadAllText(Path.Combine(System.IO.Path.GetDirectoryName(
            System.Reflection.Assembly.GetExecutingAssembly().Location)!, "appsettings.json"));

        var settings = json.DeserializeSection<T>(sectionName);

        services.AddSingleton(Options.Create(settings));

        return services;
    }

    private static JsonNode? ConvertSectionToJsonNode(IConfigurationSection section)
    {
        if (section.Value != null)
        {
            return JsonValue.Create(section.Value);
        }

        var children = section.GetChildren().ToList();
        if (children.Count == 0)
            return null;

        if (children.All(c => int.TryParse(c.Key, out _)))
        {
            var array = new JsonArray();
            foreach (var child in children.OrderBy(c => int.Parse(c.Key)))
                array.Add(ConvertSectionToJsonNode(child));
            return array;
        }

        var obj = new JsonObject();
        foreach (var child in children)
        {
            obj[child.Key] = ConvertSectionToJsonNode(child);
        }

        return obj;
    }
}
