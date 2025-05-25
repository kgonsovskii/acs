using System.ComponentModel;
using Contour.Application;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Controllers;

[ApiController]
[Route("api/[controller]/")]
public class GeneralController : ProtoController
{
    [HttpGet("status")]
    [Description("Returns application status")]
    [ProducesResponseType(typeof(StatusResponse), StatusCodes.Status200OK)]
    [Produces("application/json")]
    public ActionResult<StatusResponse> GetStatus([FromQuery] StatusRequest request)
    {
        var response = new StatusResponse
        {
            TraceId = request.TraceId,
            Status = "OK",
            TimeStamp = DateTime.Now.ToLongTimeString()
        };
        return Ok(response);
    }
}
