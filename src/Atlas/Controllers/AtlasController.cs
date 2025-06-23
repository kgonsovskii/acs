using System.ComponentModel;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Atlas.Api;
using SevenSeals.Tss.Atlas.Services;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas.Controllers;

public class AtlasController : ProtoController<Map, Map>
{
    private readonly IAtlasService _atlasService;

    public AtlasController(IAtlasService atlasService, Settings settings) : base(settings)
    {
        _atlasService = atlasService;
    }

    [HttpGet(nameof(Schema))]
    public ActionResult<Map> Schema()
    {
        return OkProto(_atlasService.Schema());
    }

    [HttpPut(nameof(Schema))]
    public ActionResult Schema(Map schema)
    {
        _atlasService.Schema(schema);
        return NoContent();
    }

    [HttpGet(nameof(Plot))]
    [Description("Plot atlas Schema")]
    [ProducesResponseType(typeof(PlotResponse), StatusCodes.Status200OK)]
    [Produces("application/json")]
    public ActionResult Plot()
    {
        var response = _atlasService.Plot();
        return OkProto(response);
    }
}
