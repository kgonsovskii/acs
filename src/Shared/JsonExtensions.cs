using System.Text.Json;

namespace SevenSeals.Tss.Shared;

public static class JsonExtensions
{
    public static string Serialize(this object obj)
    {
        return JsonSerializer.Serialize(obj, Services.JsonSerializerOptions);
    }

    public static void SerializeToFile(this object obj, string path)
    {
        File.WriteAllText(path, obj.Serialize());
    }

    public static void Serialize<TValue>(this TValue value, Utf8JsonWriter writer,
        JsonSerializerOptions? options = null)
    {
        options = Services.JsonSerializerOptions;
        JsonSerializer.Serialize(writer, value, options);
    }

    public static void Serialize(this object value, Type desiredType, Utf8JsonWriter writer,
        JsonSerializerOptions? options = null)
    {
        options = Services.JsonSerializerOptions;
        JsonSerializer.Serialize(writer, value, desiredType, options);
    }

    public static T? Deserialize<T>(this string json, JsonSerializerOptions? options = null)
    {
        options = Services.JsonSerializerOptions;
        return JsonSerializer.Deserialize<T>(json, options);
    }

    public static object Deserialize(this string json, Type targetType, JsonSerializerOptions? options = null)
    {
        options = Services.JsonSerializerOptions;
        return JsonSerializer.Deserialize(json, targetType, options)!;
    }

    public static T? DeserializeSection<T>(this string json, string sectionPath, JsonSerializerOptions? options = null)
    {
        options = Services.JsonSerializerOptions ?? options;

        var document = JsonDocument.Parse(json);
        var sectionValue = document.RootElement.GetProperty(sectionPath);

        using var stream = new MemoryStream();
        using var writer = new Utf8JsonWriter(stream);
        sectionValue.WriteTo(writer);
        writer.Flush();
        stream.Position = 0;

        return JsonSerializer.Deserialize<T>(stream, options);
    }
}
