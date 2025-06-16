using System.Diagnostics.CodeAnalysis;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Atlas.Storage;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas.Controllers;

[ApiController]
[Route("api/atlas/[controller]")]
public class ZoneController : ProtoStorageController<Zone, Guid, IZoneStorage, AtlasRequestBase, AtlasResponseBase>
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public ZoneController(IZoneStorage storage, Settings settings) : base(storage, settings)
    {
    }
}
