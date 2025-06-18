using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public interface ITransitClient: IProtoStorageClient<Transit, Transit, Guid>;

public class TransitClient : ProtoStorageClient<Transit, Transit, Guid>, ITransitClient
{
    public TransitClient(HttpClient httpClient, Settings settings, IOptions<AtlasClientOptions> options, ILogger<TransitClient> logger) : base(httpClient, settings, options, logger)
    {
    }
}
