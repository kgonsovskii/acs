namespace SevenSeals.Tss.Atlas;

public class TransitRequest: AtlasRequestBase
{
    public Guid FromZoneId { get; set; }
    public Guid ToZoneId { get; set; }
    public bool IsBidirectional { get; set; } = true;
}

public class TransitUpdateRequest : TransitRequest
{
    public Guid Id { get; set; }
}
