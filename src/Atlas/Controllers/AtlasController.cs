using System.Diagnostics.CodeAnalysis;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Atlas.Services;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas.Controllers;

public class AtlasController : ProtoController<Map, Map>
{
    private readonly IAtlasService _atlasService;

    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public AtlasController(IAtlasService atlasService, Settings settings) : base(settings)
    {
        _atlasService = atlasService;
    }

    [HttpGet(nameof(Schema))]
    public ActionResult<Map> Schema()
    {
        return Ok(_atlasService.Schema());
    }

    [HttpPut(nameof(Schema))]
    public ActionResult Schema(Map schema)
    {
        _atlasService.Schema(schema);
        return NoContent();
    }
}
