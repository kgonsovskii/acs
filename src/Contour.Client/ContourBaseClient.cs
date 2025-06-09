using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public abstract class ContourBaseClient: ProtoClient
{
    public ContourBaseClient(HttpClient httpClient, Settings settings, IOptions<ContourClientOptions> options, ILogger<ContourBaseClient> logger) : base(httpClient, settings.Agent, logger)
    {
        httpClient.BaseAddress = new Uri(options.Value.BaseUri);
    }
}
