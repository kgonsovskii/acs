using System.ComponentModel;
using System.Reflection;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Shared.Model;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoController: ControllerBase
{
    /// <summary>
    /// Returns a basic health check response indicating the service is alive.
    /// </summary>
    /// <param name="request">Optional request that carries trace context.</param>
    /// <returns>StatusResponse with service name, status, timestamp, and trace ID.</returns>
    [HttpGet("status")]
    [Description("Returns application status (heartbeat)")]
    [ProducesResponseType(typeof(StatusResponse), StatusCodes.Status200OK)]
    [Produces("application/json")]
    public ActionResult<StatusResponse> GetStatus([FromQuery] StatusRequest request)
    {
        var response = new StatusResponse
        {
            Service = Assembly.GetEntryAssembly()!.GetName().FullName,
            TraceId = request.TraceId,
            Status = "OK",
            TimeStamp = DateTime.Now.ToLongTimeString()
        };
        return Ok(response);
    }
}
