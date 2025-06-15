namespace SevenSeals.Tss.Codex;

public class Route : CodexBase
{
    public Guid FromZoneId { get; set; }
    public Guid ToZoneId { get; set; }
    public bool IsBidirectional { get; set; }
    public List<Guid> RequiredAccessLevels { get; set; } = new();
    public List<TimeZoneRule> TimeZoneRules { get; set; } = new();
    public bool IsActive { get; set; } = true;
} 