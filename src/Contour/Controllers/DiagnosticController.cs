using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Contour.Diagnostic;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Controllers;

public class DiagnosticController: BaseController
{
    private readonly ContourHub _contourHub;

    public DiagnosticController(ContourHub contourHub, Settings settings): base(settings)
    {
        _contourHub = contourHub;
    }

    [HttpPost(nameof(MainClient))]
    [ProducesResponseType(typeof(ContourResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<ContourResponse>> MainClient([FromBody] MainClientRequest request)
    {
        var spot = await _contourHub.GetContour(request);
        return OkSpot(spot, request, null);
    }

    [HttpPost(nameof(ProgId))]
    [ProducesResponseType(typeof(ContourResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<ValueResponse>> ProgId([FromBody] ContourRequest request)
    {
        var spot = await _contourHub.GetContour(request);
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
    public async Task<ActionResult<ValueResponse>> ProgVer([FromBody] ContourRequest request)
    {
        var spot = await _contourHub.GetContour(request);
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
    public async Task<ActionResult<ValueResponse>> SerNum([FromBody] ContourRequest request)
    {
        var spot = await _contourHub.GetContour(request);
        var response = new ValueResponse()
        {
            Name = nameof(SerNum),
            Value = spot.SerNum.ToString()
        };
        return OkSpot(spot, request, response);
    }
}
