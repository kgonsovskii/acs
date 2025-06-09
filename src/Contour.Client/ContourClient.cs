using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class ContourClient: ContourBaseClient
{
    public ContourClient(HttpClient httpClient, Settings settings, IOptions<ContourClientOptions> options, ILogger<ContourBaseClient> logger) : base(httpClient, settings, options, logger)
    {

    }

    public async Task<StateResponse> State(StateRequest request)
        => await PostAsync<StateRequest, StateResponse>(nameof(State), request);

    public async Task<EventsResponse> Events(EventsRequest request)
        => await PostAsync<EventsRequest, EventsResponse>(nameof(Events), request);

    public async Task<SpotResponse> Link(SpotRequest request)
        => await PostAsync<SpotRequest, SpotResponse>(nameof(Link), request);

    public async Task<SpotResponse> RelayOn(RelayOnRequest request)
        => await PostAsync<RelayOnRequest, SpotResponse>(nameof(RelayOn), request);

    public async Task<SpotResponse> RelayOff(RelayOffRequest request)
        => await PostAsync<RelayOffRequest, SpotResponse>(nameof(RelayOff), request);
}
