using Infra.Db.Attributes;
using System.ComponentModel;

namespace SevenSeals.Tss.Actor;

[DbTable]
[TypeConverter(typeof(ExpandableObjectConverter))]
public class Member: ActorBase
{
    [TypeConverter(typeof(ExpandableObjectConverter))]
    [DbPolymorphicTable(typeof(Person), typeof(Drone))]
    public MemberBase Data { get; set; } = new Person();
    public Person AsPerson() => (Data as Person)!;
    public Drone AsDrone() => (Data as Drone)!;
}
