namespace SevenSeals.Tss.Atlas;

public class Zone:AtlasBase
{
    public ZoneTypeEnum Type { get; set; }

    public Guid? ParentId { get; set; }

    public List<Zone> Children { get; set; } = new();
}
