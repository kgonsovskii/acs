using System.Runtime.Serialization;
using System.Text.Json;
using System.Text.Json.Serialization;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public enum ChannelType
{
    Ip = 0,
    ComPort = 1
}

[KnownType(typeof(ComPortOptions))]
[KnownType(typeof(IpOptions))]
[JsonDerivedType(typeof(ComPortOptions))]
[JsonDerivedType(typeof(IpOptions))]
[JsonConverter(typeof(ChannelOptionsJsonConverter))]
public abstract class ChannelOptions
{
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public virtual ChannelType Type { get; set; } = ChannelType.Ip;

    public IpOptions AsIpOptions() => (this as IpOptions)!;

    public ComPortOptions AsComPortOptions() => (this as ComPortOptions)!;
}

public class ChannelOptionsJsonConverter : JsonConverter<ChannelOptions>
{
    public override ChannelOptions Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        using var doc = JsonDocument.ParseValue(ref reader);

      if (!doc.RootElement.TryGetProperty("type", out var typeProp))
            throw new JsonException("Missing 'Type' discriminator for ChannelOptions.");

        var typeP = typeProp.GetString();
        var type = Enum.TryParse<ChannelType>(typeP, true, out var parsedType)
            ? parsedType
            : throw new JsonException($"Unknown channel type: {typeP}");

        var x = doc.RootElement.GetRawText();
        return type switch
        {
            ChannelType.ComPort => x.Deserialize<ComPortOptions>(options)!,
            ChannelType.Ip => x.Deserialize<IpOptions>(options)!,
            _ => throw new JsonException($"Unhandled channel type: {type}")
        };
    }

    public override void Write(Utf8JsonWriter writer, ChannelOptions value, JsonSerializerOptions options)
    {
        switch (value)
        {
            case ComPortOptions com:
                com.Serialize(writer, options);
                break;
            case IpOptions ip:
                ip.Serialize(writer, options);
                break;
            default:
                throw new JsonException($"Unsupported ChannelOptions type: {value.GetType().Name}");
        }
    }
}
