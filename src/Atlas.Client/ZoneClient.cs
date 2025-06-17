using System.Diagnostics.CodeAnalysis;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public interface IZoneClient: IProtoStorageClient<Zone, Zone, Guid>
{

}

public class ZoneClient : ProtoStorageClient<Zone, Zone, Guid>, IZoneClient
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public ZoneClient(HttpClient httpClient, Settings settings, IOptions<AtlasClientOptions> options, ILogger<TransitClient> logger) : base(httpClient, settings, options, logger)
    {
    }
}
