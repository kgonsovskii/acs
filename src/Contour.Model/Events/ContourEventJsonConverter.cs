using System.Text.Json;
using System.Text.Json.Serialization;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Events;


public class ContourEventJsonConverter : JsonConverter<ContourEvent>
{
    private const string TypePropertyName = "$type";

    public override ContourEvent Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        if (reader.TokenType != JsonTokenType.StartObject)
        {
            throw new JsonException("Expected start of object");
        }

        using var jsonDocument = JsonDocument.ParseValue(ref reader);
        var rootElement = jsonDocument.RootElement;

        if (!rootElement.TryGetProperty(TypePropertyName, out var typeElement))
        {
            throw new JsonException($"Missing '{TypePropertyName}' property");
        }

        var typeName = typeElement.GetString();
        if (string.IsNullOrEmpty(typeName))
        {
            throw new JsonException($"'{TypePropertyName}' property cannot be null or empty");
        }

        var concreteType = typeName switch
        {
            "ContourKeyEvent" => typeof(ContourKeyEvent),
            "ContourButtonEvent" => typeof(ContourButtonEvent),
            "ContourDoorOpenEvent" => typeof(ContourDoorOpenEvent),
            "ContourDoorCloseEvent" => typeof(ContourDoorCloseEvent),
            "ContourPower220VEvent" => typeof(ContourPower220VEvent),
            "ContourCaseEvent" => typeof(ContourCaseEvent),
            "ContourTimerEvent" => typeof(ContourTimerEvent),
            "ContourAutoTimeoutEvent" => typeof(ContourAutoTimeoutEvent),
            "ContourRestartEvent" => typeof(ContourRestartEvent),
            "ContourStartEvent" => typeof(ContourStartEvent),
            "ContourStaticSensorEvent" => typeof(ContourStaticSensorEvent),
            "ContourUnknownEvent" => typeof(ContourUnknownEvent),
            _ => throw new JsonException($"Unknown type: {typeName}")
        };

        var jsonString = rootElement.GetRawText();
        return (ContourEvent)jsonString.Deserialize(concreteType)!;
    }

    public override void Write(Utf8JsonWriter writer, ContourEvent value, JsonSerializerOptions options)
    {
        writer.WriteStartObject();

        writer.WriteString(TypePropertyName, value.GetType().Name);

        var newOptions = new JsonSerializerOptions(options);
        newOptions.Converters.Remove(this);

        var jsonString = JsonSerializer.Serialize(value, value.GetType(), newOptions);
        using var document = JsonDocument.Parse(jsonString);
        var rootElement = document.RootElement;

        foreach (var property in rootElement.EnumerateObject())
        {
            if (property.Name != TypePropertyName)
            {
                property.WriteTo(writer);
            }
        }

        writer.WriteEndObject();
    }
}
