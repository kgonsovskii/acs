using System.ComponentModel;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Controllers;

[ApiController][Route("api")]
public class GeneralController : ProtoController
{
    private readonly ChannelHub _channelHub;
    public GeneralController(ChannelHub channelHub)
    {
        _channelHub = channelHub;
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
    [HttpPost("link")]
    [Description("Connects to a spot device using host and port or an existing session ID.")]
    [ProducesResponseType(typeof(SpotResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public async Task<ActionResult<SpotResponse>> Link([FromBody] SpotRequest request)
    {
        var channel = (IpChannel) await _channelHub.OpenIpChannel(request.Host, (int)request.Port);
        var adr = byte.Parse(request.Address);
        var spot = new Spot(channel, adr);
        spot.RelayOn(1,3, true);
        var result = new SpotResponse()
        {
            TraceId = request.TraceId,
            SessionId = channel.Id,
        };
        return Ok(result);
    }
}
