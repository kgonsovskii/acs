using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Snapshot;

namespace SevenSeals.Tss.Contour;

public class SnapshotClient: ContourBaseClient
{
    public SnapshotClient(HttpClient httpClient, IOptions<ContourClientOptions> options, ILogger<ContourBaseClient> logger) : base(httpClient, options, logger)
    {
    }

    public async Task<StateResponse> State(StateRequest request)
        => await PostAsync<StateRequest, StateResponse>(nameof(State), request);

    public async Task<EventsResponse> Events(EventsRequest request)
        => await PostAsync<EventsRequest, EventsResponse>(nameof(Events), request);

}
