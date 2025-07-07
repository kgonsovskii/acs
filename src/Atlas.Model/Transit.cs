using Infra.Db.Attributes;
using SevenSeals.Tss.Contour;

namespace SevenSeals.Tss.Atlas;

[DbTable]
public class Transit: AtlasBase
{
    [DbForeignKey(typeof(Zone))]
    public Guid FromZoneId { get; set; }

    [DbForeignKey(typeof(Zone))]
    public Guid ToZoneId { get; set; }
    public bool IsBidirectional { get; set; } = true;

    [DbForeignKey(typeof(Spot))]
    public Guid? SpotId { get; set; }
}
