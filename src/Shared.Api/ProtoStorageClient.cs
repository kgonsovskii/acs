using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoStorageClient<TRequest, TResponse, TId>: ProtoClient where TRequest : IProtoRequest where TResponse : IProtoResponse
{
    protected ProtoStorageClient(HttpClient httpClient, Settings settings, IOptions<ClientOptions> options, ILogger<ProtoClient<ClientOptions>> logger) : base(httpClient, settings, options, logger)
    {
    }

    protected ProtoStorageClient(HttpClient httpClient, string agent, ILogger logger) : base(httpClient, agent, logger)
    {
    }

    protected ProtoStorageClient(string baseUri, string agent, Action<string> logAction) : base(baseUri, agent, logAction)
    {
    }

    public async Task<IEnumerable<TResponse>> GetAll()
    {
        throw new NotImplementedException();
    }

    public async Task<TResponse> GetById(TId id)
        => await GetAsync<TResponse>($"{id}");

    public async Task<TResponse> Add(TRequest request)
        => await PostAsync<TRequest, TResponse>("", request);

    public async Task<TResponse> Update(TId id, TRequest request)
        => await PutAsync<TRequest, TResponse>($"{id}", request);

    public async Task Delete(TId id)
        => await DeleteAsync($"{id}");
}
