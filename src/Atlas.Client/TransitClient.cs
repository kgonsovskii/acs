using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public class TransitClient : ProtoStorageClient<TransitRequest, TransitResponse, Guid>
{
    public TransitClient(HttpClient httpClient, Settings settings, IOptions<AtlasClientOptions> options, ILogger<TransitClient> logger) : base(httpClient, settings, options, logger)
    {
    }
}
