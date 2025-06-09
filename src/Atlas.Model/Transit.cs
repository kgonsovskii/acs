namespace SevenSeals.Tss.Atlas;

public class Transit:AtlasBase
{
    public Guid Id { get; set; }

    public Guid FromZoneId { get; set; }
    public Guid ToZoneId { get; set; }

    public string Name { get; set; }

    public bool IsBidirectional { get; set; } = true;
}
