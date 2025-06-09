using System.ComponentModel;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Controllers;

public class ContourController : BaseController
{
    private readonly SpotHub _spotHub;
    private readonly AppSnapshot _snapshot;
    public ContourController(SpotHub spotHub, AppSnapshot snapshot, Settings settings): base(settings)
    {
        _spotHub = spotHub;
        _snapshot = snapshot;
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
        spot.RelayOn(request.RelayPort, request.Interval, request.SuppressDoorEvent);
        return Ok(spot, request, null);
    }

    [HttpPost(nameof(RelayOff))]
    [ProducesResponseType(typeof(SpotResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<SpotResponse>> RelayOff([FromBody] RelayOffRequest request)
    {
        var spot = await _spotHub.GetSpot(request);
        spot.RelayOff(request.RelayPort);
        return Ok(spot, request, null);
    }

    [HttpPost(nameof(State))]
    [ProducesResponseType(typeof(StateResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<StateResponse>> State([FromBody] StateRequest request)
    {
        var response = new StateResponse()
        {
            State = _snapshot.State
        };
        return OkBase(request, response);
    }

    [HttpPost(nameof(Events))]
    [ProducesResponseType(typeof(EventsResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<EventsResponse>> Events([FromBody] EventsRequest request)
    {
        var response = new EventsResponse()
        {
            Events = _snapshot.Events
        };
        _snapshot.Clean();
        return OkBase(request, response);
    }
}
