namespace SevenSeals.Tss.Atlas;

public partial class AtlasClient : AtlasBaseClient
{

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
}
