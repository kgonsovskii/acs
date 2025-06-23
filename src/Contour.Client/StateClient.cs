using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public interface IStateClient: IProtoClient
{
    public Task<StateResponse> State(StateRequest request);

    public Task<EventsResponse> Events(EventsRequest request);
}

public class StateClient: ProtoStatefulClient, IStateClient
{
    public StateClient(HttpClient httpClient, Settings settings, IOptions<ContourClientOptions> options, ILogger<ContourClient> logger) : base(httpClient, settings, options, logger)
    {

    }

    public async Task<StateResponse> State(StateRequest request)
        => await PostAsync<StateRequest, StateResponse>(nameof(State), request);

    public async Task<EventsResponse> Events(EventsRequest request)
        => await PostAsync<EventsRequest, EventsResponse>(nameof(Events), request);
}
