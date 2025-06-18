using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public interface IAtlasClient: IProtoClient
{
    public Task<Map> Schema();

    public Task Schema(Map schema);
}

public class AtlasClient: ProtoClient, IAtlasClient
{
    public AtlasClient(HttpClient httpClient, Settings settings, IOptions<AtlasClientOptions> options, ILogger<ProtoClient<ClientOptions>> logger) : base(httpClient, settings, options, logger)
    {
    }

    public async Task<Map> Schema()
        => await GetAsync<Map>(nameof(Schema));

    public async Task Schema(Map schema)
        => await PutAsync<Map, Map>(nameof(Schema), schema);
}
