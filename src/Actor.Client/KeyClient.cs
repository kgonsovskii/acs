using System.Diagnostics.CodeAnalysis;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public interface IKeyClient: IProtoStorageClient<Key, Key, Guid>
{

}

public class KeyClient : ProtoStorageClient<Key, Key, Guid>, IKeyClient
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public KeyClient(HttpClient httpClient, Settings settings, IOptions<ActorClientOptions> options,
        ILogger<KeyClient> logger) : base(httpClient, settings, options, logger)
    {

    }
}
