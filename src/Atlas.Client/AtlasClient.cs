using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public class AtlasClient : AtlasBaseClient
{
    public AtlasClient(HttpClient httpClient, Settings settings, IOptions<AtlasClientOptions> options, ILogger<AtlasBaseClient> logger)
        : base(httpClient, settings, options, logger)
    {
    }

    #region Zones

    public async Task<IEnumerable<ZoneResponse>> GetAllZones()
        => await GetAsync<IEnumerable<ZoneResponse>>("zones");

    public async Task<ZoneResponse> GetZone(Guid id)
        => await GetAsync<ZoneResponse>($"zones/{id}");

    public async Task<ZoneResponse> CreateZone(ZoneRequest request)
        => await PostAsync<ZoneRequest, ZoneResponse>("zones", request);

    public async Task<ZoneResponse> UpdateZone(Guid id, ZoneRequest request)
        => await PutAsync<ZoneRequest, ZoneResponse>($"zones/{id}", request);

    public async Task DeleteZone(Guid id)
        => await DeleteAsync($"zones/{id}");

    #endregion

    #region Transits

    public async Task<IEnumerable<TransitResponse>> GetAllTransits()
        => await GetAsync<IEnumerable<TransitResponse>>("transits");

    public async Task<TransitResponse> GetTransit(Guid id)
        => await GetAsync<TransitResponse>($"transits/{id}");

    public async Task<TransitResponse> CreateTransit(TransitRequest request)
        => await PostAsync<TransitRequest, TransitResponse>("transits", request);

    public async Task<TransitResponse> UpdateTransit(Guid id, TransitRequest request)
        => await PutAsync<TransitRequest, TransitResponse>($"transits/{id}", request);

    public async Task DeleteTransit(Guid id)
        => await DeleteAsync($"transits/{id}");

    #endregion

    #region Schema

    public async Task<MapResponse> Schema()
        => await GetAsync<MapResponse>(nameof(Schema));

    public async Task Schema(MapRequest schema)
        => await PutAsync<MapRequest, MapResponse>(nameof(Schema), schema);

    #endregion
}
