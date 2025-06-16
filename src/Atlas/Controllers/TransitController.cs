using System.Diagnostics.CodeAnalysis;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Atlas.Storage;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TransitController : ProtoStorageController<Transit, Guid, ITransitStorage, AtlasRequestBase, AtlasResponseBase>
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public TransitController(ITransitStorage storage, Settings settings) : base(storage, settings)
    {
    }
}
