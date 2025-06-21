using Infra.Db.Attributes;

namespace SevenSeals.Tss.Actor;

public class Person: MemberBase
{
    public override MemberType Type { get; set; } = MemberType.Person;
    [DbNull] public string? Email { get; set; }
    [DbNull] public string? Phone { get; set; }
}
