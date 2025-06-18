using Infra.Db;

namespace SevenSeals.Tss.Actor;

[DbTable]
public class Actor: ActorBase
{
    [DbPolymorphicTable(typeof(Person), typeof(Drone))]
    public Card Card { get; set; } = new Person();
    public Person AsPerson() => (Card as Person)!;
    public Drone AsDrone() => (Card as Drone)!;
}
