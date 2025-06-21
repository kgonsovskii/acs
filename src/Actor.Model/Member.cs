using Infra.Db;
using Infra.Db.Attributes;

namespace SevenSeals.Tss.Actor;

[DbTable]
public class Member: ActorBase
{
    [DbPolymorphicTable(typeof(Person), typeof(Drone))]
    public MemberBase Data { get; set; } = new Person();
    public Person AsPerson() => (Data as Person)!;
    public Drone AsDrone() => (Data as Drone)!;
}
