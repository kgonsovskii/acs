using System.Diagnostics.CodeAnalysis;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public class ActorClient : ActorBaseClient
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public ActorClient(HttpClient httpClient, Settings settings, IOptions<ActorClientOptions> options,
        ILogger<ActorBaseClient> logger) : base(httpClient, settings, options, logger)
    {

    }
}
