using Contour.Application;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace Contour;

public class ContourClient: ProtoClient
{
    public ContourClient(IOptions<ContourClientOptions> options, ILogger<ContourClient> logger) : base(options.Value.BaseUri, logger)
    {
    }

    public ContourClient(HttpClient httpClient, Action<string> loggerAction) : base(httpClient, loggerAction)
    {
    }

    public async Task<StatusResponse> GetStatus(StatusRequest statusRequest)
        => await GetAsync<StatusRequest, StatusResponse>(statusRequest);
}
