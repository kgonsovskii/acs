using System.Text.Json;
using System.Text.Json.Serialization;
using SevenSeals.Tss.Web.Api.Models;

namespace SevenSeals.Tss.Web.Api.JsonConverters
{
    public class ShapeJsonConverter : JsonConverter<Shape>
    {
        public override Shape Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            if (reader.TokenType != JsonTokenType.StartObject)
            {
                throw new JsonException();
            }

            using var jsonDocument = JsonDocument.ParseValue(ref reader);
            var jsonElement = jsonDocument.RootElement;

            if (!jsonElement.TryGetProperty("type", out var typeProperty))
            {
                throw new JsonException("Missing 'type' property");
            }

            var type = typeProperty.GetString();
            return type switch
            {
                "rect" => JsonSerializer.Deserialize<RectangleShape>(jsonElement.GetRawText(), options),
                "transit" => JsonSerializer.Deserialize<TransitShape>(jsonElement.GetRawText(), options),
                _ => throw new JsonException($"Unknown shape type: {type}")
            };
        }

        public override void Write(Utf8JsonWriter writer, Shape value, JsonSerializerOptions options)
        {
            JsonSerializer.Serialize(writer, value, value.GetType(), options);
        }
    }
}
