using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public abstract class AtlasBaseClient : ProtoClient
{
    public AtlasBaseClient(HttpClient httpClient, Settings settings, IOptions<AtlasClientOptions> options, ILogger<AtlasBaseClient> logger) 
        : base(httpClient, settings.Agent, logger)
    {
        httpClient.BaseAddress = new Uri(options.Value.BaseUri);
    }
} 