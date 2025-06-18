using System.Text.Json;
using System.Text.Json.Serialization;

namespace SevenSeals.Tss.Shared;

public class GenericDiscriminantConverter<TEnum, TBase>: JsonConverter<TBase> where TEnum : struct, Enum where TBase: class
{
    private Dictionary<Enum, Type> _map;
    public GenericDiscriminantConverter(Dictionary<Enum, Type> map)
    {
        _map = map;
    }
    public override TBase Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        using var doc = JsonDocument.ParseValue(ref reader);

        if (!doc.RootElement.TryGetProperty("type", out var typeProp))
            throw new JsonException($"Missing 'Type' discriminator for {nameof(TBase)} .");

        var typeP = typeProp.GetString();
        var type = Enum.TryParse<TEnum>(typeP, true, out var parsedType)
            ? parsedType
            : throw new JsonException($"Unknown {nameof(TEnum)} type: {typeP}");

        var x = doc.RootElement.GetRawText();
        var targetType = _map[type];
        var result = x.Deserialize(targetType, options);
        return (TBase)result;
    }

    public override void Write(Utf8JsonWriter writer, TBase value, JsonSerializerOptions options)
    {
        var type = value.GetType();
        value.Serialize(type, writer, options);
    }
}
