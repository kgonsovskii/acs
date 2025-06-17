using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Contour.Diagnostic;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Controllers;

public class DiagnosticController: BaseController
{
    private readonly SpotHub _spotHub;

    public DiagnosticController(SpotHub spotHub, Settings settings): base(settings)
    {
        _spotHub = spotHub;
    }

    [HttpPost(nameof(MainClient))]
    [ProducesResponseType(typeof(SpotResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<SpotResponse>> MainClient([FromBody] MainClientRequest request)
    {
        var spot = await _spotHub.GetSpot(request);
        return OkSpot(spot, request, null);
    }

    [HttpPost(nameof(ProgId))]
    [ProducesResponseType(typeof(SpotResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<ValueResponse>> ProgId([FromBody] SpotRequest request)
    {
        var spot = await _spotHub.GetSpot(request);
        var response = new ValueResponse()
        {
            Name = nameof(ProgId),
            Value = spot.ProgId.ToString()
        };
        return OkSpot(spot, request, response);
    }

    [HttpPost(nameof(ProgVer))]
    [ProducesResponseType(typeof(ValueResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<ValueResponse>> ProgVer([FromBody] SpotRequest request)
    {
        var spot = await _spotHub.GetSpot(request);
        var response = new ValueResponse()
        {
            Name = nameof(ProgVer),
            Value = spot.ProgVer.ToString()
        };
        return OkSpot(spot, request, response);
    }

    [HttpPost(nameof(SerNum))]
    [ProducesResponseType(typeof(ValueResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<ValueResponse>> SerNum([FromBody] SpotRequest request)
    {
        var spot = await _spotHub.GetSpot(request);
        var response = new ValueResponse()
        {
            Name = nameof(SerNum),
            Value = spot.SerNum.ToString()
        };
        return OkSpot(spot, request, response);
    }
}
