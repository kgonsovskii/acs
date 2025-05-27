using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;
using SevenSeals.Tss.Shared.Model;

namespace SevenSeals.Tss.Contour;

public class ContourClient: ProtoClient
{
    public ContourClient(IOptions<ContourClientOptions> options, ILogger<ContourClient> logger) : base(options.Value.BaseUri, logger)
    {
    }

    public ContourClient(HttpClient httpClient, Action<string> loggerAction) : base(httpClient, loggerAction)
    {
    }

    public async Task<StatusResponse> GetStatus(StatusRequest statusRequest)
        => await GetAsync<StatusRequest, StatusResponse>("status", statusRequest);

    public async Task<SpotResponse> Link(SpotRequest spotRequest)
        => await PostAsync<SpotRequest, SpotResponse>("link", spotRequest);
}
