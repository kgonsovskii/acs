using Microsoft.AspNetCore.Mvc;

namespace SevenSeals.Tss.Codex.Controllers;

[ApiController]
[Route("api/[controller]")]
public abstract class BaseController : ControllerBase
{
    protected ActionResult<T> OkOrNotFound<T>(T? result)
    {
        if (result == null)
        {
            return NotFound();
        }
        return Ok(result);
    }

    protected ActionResult<T> CreatedOrBadRequest<T>(T? result, string routeName, object routeValues)
    {
        if (result == null)
        {
            return BadRequest();
        }
        return CreatedAtRoute(routeName, routeValues, result);
    }
} 