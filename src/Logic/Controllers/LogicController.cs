using System.ComponentModel;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Logic.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Logic.Controllers;

public class LogicController : BaseController
{
    private readonly ILogicService _service;
    private readonly Settings _settings;

    public LogicController(ILogicService logicService, Settings settings) : base(settings)
    {
        _service = logicService;
        _settings = settings;
    }

    /// <summary>
    /// Simulate event
    /// </summary>
    [HttpPut(nameof(FirePassTouched))]
    [Description("Simulate event")]
    [ProducesResponseType(typeof(PassTouchedResponse), StatusCodes.Status200OK)]
    [Produces("application/json")]
    public async Task<ActionResult<PassTouchedResponse>> FirePassTouched([FromBody] PassTouchedRequest request)
    {
        var response = await _service.OnPassTouched(request);

        return OkProto(response);
    }
}
