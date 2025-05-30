using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Shared;
using Snapshot;

namespace SevenSeals.Tss.Contour.Controllers;

public class SnapshotController : BaseController
{
    private readonly AppSnapshot _snapshot;

    public SnapshotController(AppSnapshot snapshot, Settings settings): base(settings)
    {
        _snapshot = snapshot;
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
