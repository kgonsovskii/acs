using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public interface IContourClient: IProtoClient
{
    public Task<ContourResponse> Link(ContourRequest request);

    public Task<ContourResponse> RelayOn(RelayOnRequest request);

    public Task<ContourResponse> RelayOff(RelayOffRequest request);

    public Task<StateResponse> State(StateRequest request);
}

public class ContourClient: ProtoClient, IContourClient
{
    public ContourClient(HttpClient httpClient, Settings settings, IOptions<ContourClientOptions> options, ILogger<ContourClient> logger) : base(httpClient, settings, options, logger)
    {

    }

    public async Task<StateResponse> State(StateRequest request)
        => await PostAsync<StateRequest, StateResponse>(nameof(State), request);

    public async Task<ContourResponse> Link(ContourRequest request)
        => await PostAsync<ContourRequest, ContourResponse>(nameof(Link), request);

    public async Task<ContourResponse> RelayOn(RelayOnRequest request)
        => await PostAsync<RelayOnRequest, ContourResponse>(nameof(RelayOn), request);

    public async Task<ContourResponse> RelayOff(RelayOffRequest request)
        => await PostAsync<RelayOffRequest, ContourResponse>(nameof(RelayOff), request);
}
