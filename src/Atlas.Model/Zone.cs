using Infra.Db;

namespace SevenSeals.Tss.Atlas;

[DbTable]
public class Zone:AtlasBase
{
    [DbEnumTable]
    public ZoneType Type { get; set; }

    public Guid? ParentId { get; set; }

    [DbChildTable]
    public List<Zone> Children { get; set; } = [];
}
