using Infra.Db;
using Infra.Db.Attributes;

namespace SevenSeals.Tss.Actor;

[DbTable]
public class Pass: ActorBase
{
    public string? Number { get; set; }
    [DbEnumTable] public PassType Type { get; set; }
    [DbEnumTable] public PassStatus Status { get; set; }
    public DateTime IssueDate { get; set; }
    public DateTime? ExpiryDate { get; set; }
}

public enum PassType
{
    Physical,
    Virtual,
    Card,
    Mobile
}

public enum PassStatus
{
    Active,
    Lost,
    Stolen,
    Expired,
    Deactivated
}
