using System.ComponentModel;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Logic.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Logic.Controllers;

public class LogicController : BaseController
{
    private readonly ClientEvents _events;
    public LogicController(Settings settings, ClientEvents events) : base(settings)
    {
        _events = events;
    }

    /// <summary>
    /// Events for Client
    /// </summary>
    [HttpPut(nameof(OnClientEvent))]
    [Description("CallBack event initiated by Contour")]
    [ProducesResponseType(typeof(CallBackResponse), StatusCodes.Status200OK)]
    [Produces("application/json")]
    public async Task<ActionResult<List<PassTouchedClientEvent>>> OnClientEvent(ProtoRequest request)
    {
        var events = _events.Events.ToList();
        _events.Events.Clear();
        return OkProto(events);
    }
}
