using System.Runtime.Serialization;
using System.Text.Json.Serialization;
using Infra.Db;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public enum CardType
{
    Person,
    Drone
}

[JsonConverter(typeof(CardJsonConverter))]
[KnownType(typeof(Person))]
[KnownType(typeof(Drone))]
[JsonDerivedType(typeof(Person))]
[JsonDerivedType(typeof(Drone))]
public abstract class Card
{
    [DbEnumTable]
    public virtual CardType Type { get; set; } = CardType.Person;
}

public class CardJsonConverter : GenericDiscriminantConverter<CardType, Card>
{
    public CardJsonConverter() : base(new Dictionary<Enum, Type>()
    {
        { CardType.Person, typeof(Person) },
        { CardType.Drone, typeof(Drone) }
    }) { }
}
