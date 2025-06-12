using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;


public class TransitResponse: ResponseBase
{
    public Guid Id { get; set; }
    public Guid FromZoneId { get; set; }
    public Guid ToZoneId { get; set; }
    public bool IsBidirectional { get; set; }
    public string FromZoneName { get; set; } = string.Empty;
    public string ToZoneName { get; set; } = string.Empty;
}
