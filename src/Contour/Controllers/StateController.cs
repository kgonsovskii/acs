using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Controllers;

public class StateController : ProtoStatefulController
{
    private readonly AppSnapshot _snapshot;

    public StateController(ContourHub contourHub, AppSnapshot snapshot, Settings settings): base(settings)
    {
        _snapshot = snapshot;
    }

    [HttpPost(nameof(State))]
    [ProducesResponseType(typeof(StateResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public ActionResult<StateResponse> State(StateRequest request)
    {
        var response = new StateResponse()
        {
            State = _snapshot.State
        };
        return OkProto(response);
    }

    [HttpPost(nameof(Events))]
    [ProducesResponseType(typeof(EventsResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [Produces("application/json")]
    public ActionResult<EventsResponse> Events(EventsRequest request)
    {
        var response = new EventsResponse()
        {
            Events = _snapshot.Events
        };
        _snapshot.Clean();
        return OkProto(response);
    }
}
