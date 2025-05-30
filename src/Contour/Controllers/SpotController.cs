using System.ComponentModel;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Shared;
using Spot;

namespace SevenSeals.Tss.Contour.Controllers;

public class SpotController : BaseController
{
    private readonly SpotHub _spotHub;
    public SpotController(SpotHub spotHub, Settings settings): base(settings)
    {
        _spotHub = spotHub;
    }
    /// <summary>
    /// Connects to a spot device using host and port, or an existing session ID.
    /// </summary>
    /// <remarks>
    /// Use this endpoint to establish a new session with a spot device by providing host and port,
    /// or reuse an existing session by supplying a valid SessionId.
    /// </remarks>
    /// <param name="request">Connection details for the spot device.</param>
    /// <response code="200">Returns a SessionId for the connected or reused session.</response>
    /// <response code="400">Returned when the request is invalid or missing required connection parameters.</response>
    [HttpPost(nameof(Link))]
    [Description("Connects to a spot device using host and port or an existing session ID.")]
    [ProducesResponseType(typeof(SpotResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<SpotResponse>> Link([FromBody] SpotRequest request)
    {
        var spot = await _spotHub.GetSpot(request, true);
        return Ok(spot, request, null);
    }

    [HttpPost(nameof(RelayOn))]
    [ProducesResponseType(typeof(SpotResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<SpotResponse>> RelayOn([FromBody] RelayOnRequest request)
    {
        var spot = await _spotHub.GetSpot(request);
        spot.RelayOn(request.SportPort, request.Interval, request.SuppressDoorEvent);
        return Ok(spot, request, null);
    }

    [HttpPost(nameof(RelayOff))]
    [ProducesResponseType(typeof(SpotResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<SpotResponse>> RelayOff([FromBody] RelayOffRequest request)
    {
        var spot = await _spotHub.GetSpot(request);
        spot.RelayOff(request.SportPort);
        return Ok(spot, request, null);
    }
}
