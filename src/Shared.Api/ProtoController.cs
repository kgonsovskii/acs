using System.ComponentModel;
using System.Reflection;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Shared.Model;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoController: ControllerBase
{
    [HttpGet("status")]
    [Description("Returns application status")]
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
