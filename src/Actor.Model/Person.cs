using Infra.Db.Attributes;
using System.ComponentModel;

namespace SevenSeals.Tss.Actor;

[TypeConverter(typeof(ExpandableObjectConverter))]
public class Person : MemberBase
{
    public override MemberType Type { get; set; } = MemberType.Person;
    [DbNull] public string? Email { get; set; }
    [DbNull] public string? Phone { get; set; }
}
