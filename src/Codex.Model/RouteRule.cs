using Infra.Db;

namespace SevenSeals.Tss.Codex;

[DbTable]
public class RouteRule : CodexBase
{
    public Guid FromZoneId { get; set; }
    public Guid ToZoneId { get; set; }
    public bool IsBidirectional { get; set; }
}
