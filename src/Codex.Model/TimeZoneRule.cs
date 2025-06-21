using Infra.Db;
using Infra.Db.Attributes;

namespace SevenSeals.Tss.Codex;

[DbTable]
public class TimeZoneRule : CodexBase
{
    [DbEnumTable(Schema = "codex")] public DayOfWeek DayOfWeek { get; set; }
    public TimeSpan StartTime { get; set; }
    public TimeSpan EndTime { get; set; }
}
