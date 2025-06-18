using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public interface IActorClient: IProtoStorageClient<Actor, Actor, Guid>;

public class ActorClient : ProtoStorageClient<Actor, Actor, Guid>, IActorClient
{
    public ActorClient(HttpClient httpClient, Settings settings, IOptions<ActorClientOptions> options,
        ILogger<ActorClient> logger) : base(httpClient, settings, options, logger)
    {

    }
}
