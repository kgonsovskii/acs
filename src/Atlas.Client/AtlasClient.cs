using System.Diagnostics.CodeAnalysis;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public class AtlasClient: ProtoClient
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public AtlasClient(HttpClient httpClient, Settings settings, IOptions<AtlasClientOptions> options, ILogger<ProtoClient<ClientOptions>> logger) : base(httpClient, settings, options, logger)
    {
    }

    public async Task<MapResponse> Schema()
        => await GetAsync<MapResponse>(nameof(Schema));

    public async Task Schema(MapRequest schema)
        => await PutAsync<MapRequest, MapResponse>(nameof(Schema), schema);
}
