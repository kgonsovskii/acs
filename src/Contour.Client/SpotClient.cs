using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Spot;

namespace SevenSeals.Tss.Contour;

public class SpotClient: ContourBaseClient
{
    public SpotClient(HttpClient httpClient, IOptions<ContourClientOptions> options, ILogger<ContourBaseClient> logger) : base(httpClient, options, logger)
    {
    }

    public async Task<SpotResponse> Link(SpotRequest request)
        => await PostAsync<SpotRequest, SpotResponse>(nameof(Link), request);

    public async Task<SpotResponse> RelayOn(RelayOnRequest request)
        => await PostAsync<RelayOnRequest, SpotResponse>(nameof(RelayOn), request);

    public async Task<SpotResponse> RelayOff(RelayOffRequest request)
        => await PostAsync<RelayOffRequest, SpotResponse>(nameof(RelayOff), request);
}
