using System.Runtime.Serialization;
using System.Text.Json;
using System.Text.Json.Serialization;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public enum ActorType
{
    Person,
    Drone
}

[KnownType(typeof(Person))]
[KnownType(typeof(Drone))]
[JsonDerivedType(typeof(Person))]
[JsonDerivedType(typeof(Drone))]
[JsonConverter(typeof(ActorJsonConverter))]
public abstract class Actor: ActorBase
{
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public virtual ActorType Type { get; set; } = ActorType.Person;

    public Person AsPerson() => (this as Person)!;

    public Drone AsDrone() => (this as Drone)!;
}

public class ActorJsonConverter : JsonConverter<Actor>
{
    public override Actor Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        using var doc = JsonDocument.ParseValue(ref reader);

        if (!doc.RootElement.TryGetProperty("type", out var typeProp))
            throw new JsonException("Missing 'Type' discriminator for ChannelOptions.");

        var typeP = typeProp.GetString();
        var type = Enum.TryParse<ActorType>(typeP, true, out var parsedType)
            ? parsedType
            : throw new JsonException($"Unknown channel type: {typeP}");

        var x = doc.RootElement.GetRawText();
        return type switch
        {
            ActorType.Person => x.Deserialize<Person>(options)!,
            ActorType.Drone => x.Deserialize<Drone>(options)!,
            _ => throw new JsonException($"Unhandled channel type: {type}")
        };
    }

    public override void Write(Utf8JsonWriter writer, Actor value, JsonSerializerOptions options)
    {
        switch (value)
        {
            case Person person:
                person.Serialize(writer, options);
                break;
            case Drone drone:
                drone.Serialize(writer, options);
                break;
            default:
                throw new JsonException($"Unsupported Actor type: {value.GetType().Name}");
        }
    }
}

