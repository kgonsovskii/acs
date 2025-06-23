using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas.Controllers;

public class ZoneController : ProtoStorageController<Zone, Guid, IZoneStorage, Zone, Zone>
{
    public ZoneController(IZoneStorage storage, Settings settings) : base(storage, settings)
    {
    }
}
