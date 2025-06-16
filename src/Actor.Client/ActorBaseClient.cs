using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public abstract class ActorBaseClient : ProtoClient
{
    public ActorBaseClient(HttpClient httpClient, Settings settings, IOptions<ActorClientOptions> options, ILogger<ActorBaseClient> logger) 
        : base(httpClient, settings.Agent, logger)
    {
        httpClient.BaseAddress = new Uri(options.Value.BaseUri);
    }
} 