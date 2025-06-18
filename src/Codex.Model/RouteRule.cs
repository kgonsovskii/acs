namespace SevenSeals.Tss.Codex;

public class RouteRule : CodexBase
{
    public Guid FromZoneId { get; set; }
    public Guid ToZoneId { get; set; }
    public bool IsBidirectional { get; set; }
}
