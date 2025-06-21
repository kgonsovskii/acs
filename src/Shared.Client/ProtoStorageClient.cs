using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace SevenSeals.Tss.Shared;

public interface IProtoStorageClient<in TRequest, TResponse, in TId> : IProtoClient
    where TRequest : IProtoRequest where TResponse : IProtoResponse
{
    public Task<IMany<TResponse>> GetAll();

    public Task<TResponse> GetById(TId id);

    public Task<TResponse> Add(TRequest request);

    public Task<TResponse> Update(TId id, TRequest request);

    public Task Delete(TId id);
}

public abstract class ProtoStorageClient<TRequest, TResponse, TId>: ProtoClient, IProtoStorageClient<TRequest, TResponse, TId> where TRequest : IProtoRequest where TResponse : IProtoResponse
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

    public virtual async Task<IMany<TResponse>> GetAll()
        => await GetManyAsync<TResponse>("");

    public virtual async Task<TResponse> GetById(TId id)
        => await GetAsync<TResponse>($"{id}");

    public virtual async Task<TResponse> Add(TRequest request)
        => await PostAsync<TRequest, TResponse>("", request);

    public virtual async Task<TResponse> Update(TId id, TRequest request)
        => await PutAsync<TRequest, TResponse>($"{id}", request);

    public virtual async Task Delete(TId id)
        => await DeleteAsync($"{id}");
}
