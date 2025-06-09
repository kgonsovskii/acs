using System.Text.Json;
using System.Text.Json.Serialization;

namespace SevenSeals.Tss.Shared;

public class JsonFlexibleConverter<T> : JsonConverter<T>
{
    public override T? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        var value = reader.TokenType switch
        {
            JsonTokenType.Number when typeof(T) == typeof(int) && reader.TryGetInt32(out var i) => i,
            JsonTokenType.Number when typeof(T) == typeof(long) && reader.TryGetInt64(out var l) => l,
            JsonTokenType.Number when typeof(T) == typeof(double) && reader.TryGetDouble(out var d) => d,
            JsonTokenType.String => ParseString(reader.GetString()),
            JsonTokenType.Number => Convert.ChangeType(reader.GetDouble(), typeof(T)),
            _ => JsonSerializer.Deserialize<object>(ref reader, options)
        };

        return (T?)value;

        object? ParseString(string? str)
        {
            if (str == null) return null;

            if (typeof(T) == typeof(int) && int.TryParse(str, out var i)) return i;
            if (typeof(T) == typeof(long) && long.TryParse(str, out var l)) return l;
            if (typeof(T) == typeof(double) && double.TryParse(str, out var d)) return d;
            if (typeof(T) == typeof(bool) && bool.TryParse(str, out var b)) return b;
            if (typeof(T) == typeof(string)) return str;

            throw new JsonException($"Cannot convert '{str}' to type {typeof(T).Name}");
        }
    }

    public override void Write(Utf8JsonWriter writer, T value, JsonSerializerOptions options)
    {
        JsonSerializer.Serialize(writer, value, value?.GetType() ?? typeof(object), options);
    }
}
