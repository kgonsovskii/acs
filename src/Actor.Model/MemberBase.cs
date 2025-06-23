using System.ComponentModel;
using System.Runtime.Serialization;
using System.Text.Json.Serialization;
using Infra.Db.Attributes;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public enum MemberType
{
    Person,
    Drone
}

[TypeConverter(typeof(ExpandableObjectConverter))]
[JsonConverter(typeof(CardJsonConverter))]
[KnownType(typeof(Person))]
[KnownType(typeof(Drone))]
[JsonDerivedType(typeof(Person))]
[JsonDerivedType(typeof(Drone))]
public abstract class MemberBase
{
    [DbEnumTable]
    public virtual MemberType Type { get; set; } = MemberType.Person;
}

public class CardJsonConverter : GenericDiscriminantConverter<MemberType, MemberBase>
{
    public CardJsonConverter() : base(new Dictionary<Enum, Type>()
    {
        { MemberType.Person, typeof(Person) },
        { MemberType.Drone, typeof(Drone) }
    }) { }
}
