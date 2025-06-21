using Infra.Db.Attributes;

namespace SevenSeals.Tss.Actor;

public class Drone : MemberBase
{
    public override MemberType Type { get; set; } = MemberType.Drone;
    [DbNull] public string? SerialNumber {get; set;} = null!;
    [DbNull] public string? FirmwareVersion {get; set;} = null!;
}
