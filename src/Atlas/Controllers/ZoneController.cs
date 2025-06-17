using System.Diagnostics.CodeAnalysis;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Atlas.Storage;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas.Controllers;

public class ZoneController : ProtoStorageController<Zone, Guid, IZoneStorage, Zone, Zone>
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public ZoneController(IZoneStorage storage, Settings settings) : base(storage, settings)
    {
    }
}
