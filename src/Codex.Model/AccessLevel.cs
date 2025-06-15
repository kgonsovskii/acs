namespace SevenSeals.Tss.Codex;

public class AccessLevel : CodexBase
{
    public int Priority { get; set; }
    public bool IsActive { get; set; } = true;
    public List<Guid> AllowedZoneIds { get; set; } = new();
    public List<Guid> ExcludedZoneIds { get; set; } = new();
    public List<Guid> ParentAccessLevelIds { get; set; } = new();
} 