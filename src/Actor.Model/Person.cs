namespace SevenSeals.Tss.Actor;

public class Person: Card
{
    public override CardType Type { get; set; } = CardType.Person;
    public string? Email { get; set; }
    public string? Phone { get; set; }
}
