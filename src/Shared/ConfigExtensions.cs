using System.Text.Json.Nodes;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace SevenSeals.Tss.Shared;

public static class ConfigurationExtensions
{
    public static IServiceCollection AddExtendedOptions<T>(
        this IServiceCollection services,
        string serviceGroup,
        string sectionName
    ) where T : class, new()
    {
        var json = File.ReadAllText(Path.Combine(System.IO.Path.GetDirectoryName(
                System.Reflection.Assembly.GetExecutingAssembly().Location)!, $"appsettings.{serviceGroup}.json"));

        var settings = json.DeserializeSection<T>(sectionName)!;

        services.AddSingleton(Options.Create<T>(settings));

        return services;
    }

    public static T GetRootValue<T>(string jsonPath, string filePath = "appsettings.base.json") where T : struct, Enum
    {
        if (!File.Exists(filePath))
            return default;
        var json = File.ReadAllText(filePath);
        var root = JsonNode.Parse(json) ?? throw new InvalidOperationException("Invalid JSON.");

        var keys = jsonPath.Split(':', StringSplitOptions.RemoveEmptyEntries);
        var current = root;

        foreach (var key in keys)
        {
            current = current?[key];
            if (current is null)
                throw new InvalidOperationException($"Path not found: {jsonPath}");
        }

        var value = current?.ToString();

        if (string.IsNullOrWhiteSpace(value))
            throw new InvalidOperationException($"Value at path '{jsonPath}' is null or empty.");

        if (!Enum.TryParse<T>(value, ignoreCase: true, out var result))
            throw new InvalidOperationException($"Cannot parse '{value}' to enum {typeof(T).Name}.");

        return result;
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

    private static string? _serviceGroup;

    public static string ServiceGroup(this object baseObject)
    {
        if (_serviceGroup == null)
        {
            var baseType = baseObject.GetType();
            var assemblies = AppDomain.CurrentDomain.GetAssemblies();

            foreach (var asm in assemblies)
            {
                if (asm.GetName()!.Name!.StartsWith("Shared"))
                    continue;

                var derivedType = asm.GetTypes()
                    .FirstOrDefault(t => t.IsClass && !t.IsAbstract && baseType.IsAssignableFrom(t));

                if (derivedType != null)
                {
                    _serviceGroup = derivedType.Assembly.GetName().Name!.Split('.')[0].ToLower();
                    return _serviceGroup;
                }
            }

            throw new Exception("No test service found for this test");
        }

        return _serviceGroup;
    }
}
