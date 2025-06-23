using System.ComponentModel;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Controllers;

public class ContourController : ProtoStatefulController
{
    private readonly ContourHub _contourHub;

    public ContourController(ContourHub contourHub, Settings settings): base(settings)
    {
        _contourHub = contourHub;
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
    [ProducesResponseType(typeof(ContourResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<ContourResponse>> Link([FromBody] ContourRequest request)
    {
        var spot = await _contourHub.GetContour(request);
        return OkSpot(spot, request, null);
    }

    [HttpPost(nameof(RelayOn))]
    [ProducesResponseType(typeof(ContourResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<ContourResponse>> RelayOn([FromBody] RelayOnRequest request)
    {
        var spot = await _contourHub.GetContour(request);
        spot.RelayOn(request.RelayPort, request.Interval, request.SuppressDoorEvent);
        return OkSpot(spot, request, null);
    }

    [HttpPost(nameof(RelayOff))]
    [ProducesResponseType(typeof(ContourResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<ContourResponse>> RelayOff([FromBody] RelayOffRequest request)
    {
        var spot = await _contourHub.GetContour(request);
        spot.RelayOff(request.RelayPort);
        return OkSpot(spot, request, null);
    }

    private OkObjectResult OkSpot(Contour contour, ContourRequest request, ContourResponse? response)
    {
        response ??= new ContourResponse()
        {
            SessionId = contour.Channel.Id
        };
        return OkProto(response);
    }

    private  static readonly object _lock = new();

    [HttpPost(nameof(State))]
    [ProducesResponseType(typeof(StateResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public ActionResult<StateResponse> State(StateRequest request)
    {
        lock (_lock)
        {
            var response = new StateResponse()
            {
                State = new ContourSnapshot()
                {
                    Events = _contourHub.GetEventsSnapshot()
                }
            };
            _contourHub.ClearEvents();
            var result = OkProto(response);
            return result;
        }
    }
}
