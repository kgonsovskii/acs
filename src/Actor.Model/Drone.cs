using Infra.Db.Attributes;
using System.ComponentModel;

namespace SevenSeals.Tss.Actor;

[TypeConverter(typeof(ExpandableObjectConverter))]
public class Drone : MemberBase
{
    public override MemberType Type { get; set; } = MemberType.Drone;
    [DbNull] public string? SerialNumber {get; set;} = null!;
    [DbNull] public string? FirmwareVersion {get; set;} = null!;
}
