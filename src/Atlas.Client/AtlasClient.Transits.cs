namespace SevenSeals.Tss.Atlas;

public partial class AtlasClient : AtlasBaseClient
{
    public async Task<IEnumerable<TransitResponse>> GetAllTransits()
        => await GetAsync<IEnumerable<TransitResponse>>("transit");

    public async Task<TransitResponse> GetTransit(Guid id)
        => await GetAsync<TransitResponse>($"transit/{id}");

    public async Task<TransitResponse> CreateTransit(TransitRequest request)
        => await PostAsync<TransitRequest, TransitResponse>("transit", request);

    public async Task<TransitResponse> UpdateTransit(Guid id, TransitRequest request)
        => await PutAsync<TransitRequest, TransitResponse>($"transit/{id}", request);

    public async Task DeleteTransit(Guid id)
        => await DeleteAsync($"transit/{id}");
}
