using System.Diagnostics.CodeAnalysis;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Atlas.Services;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas.Controllers;

public class AtlasController : ProtoController<AtlasRequestBase, AtlasResponseBase>
{
    private readonly IAtlasService _atlasService;

    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public AtlasController(IAtlasService atlasService, Settings settings) : base(settings)
    {
        _atlasService = atlasService;
    }

    [HttpGet(nameof(Schema))]
    public ActionResult<AtlasMap> Schema()
    {
        return Ok(_atlasService.Schema());
    }

    [HttpPut(nameof(Schema))]
    public ActionResult Schema(AtlasMap schema)
    {
        _atlasService.Schema(schema);
        return NoContent();
    }
}
