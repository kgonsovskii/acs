using Infra.Db.Attributes;

namespace SevenSeals.Tss.Codex;

[DbTable]
public class TimeZoneRule : CodexBase
{
    [DbEnumTable(Schema = "codex")] public DayOfWeek DayOfWeek { get; set; }
    public string StartTime { get; set; }
    public string EndTime { get; set; }
}
