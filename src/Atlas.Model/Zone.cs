namespace SevenSeals.Tss.Atlas;

public class Zone:AtlasBase
{
    public Guid Id { get; set; }

    public string Name { get; set; }
    public string Hint { get; set; }

    public ZoneTypeEnum Type { get; set; }

    public Guid? ParentId { get; set; }

    public List<Zone> Children { get; set; } = new();
}
