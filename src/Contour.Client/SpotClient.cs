using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public interface ISpotClient: IProtoStorageClient<Spot, Spot, Guid>;

public class SpotClient : ProtoStorageClient<Spot, Spot, Guid>, ISpotClient
{
    public SpotClient(HttpClient httpClient, Settings settings, IOptions<ContourClientOptions> options,
        ILogger<SpotClient> logger) : base(httpClient, settings, options, logger)
    {

    }
}
