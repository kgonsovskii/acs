using Infra;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace SevenSeals.Tss.Shared;

public interface IProtoStorageClient<in TRequest, TResponse, in TId> : IProtoClient
    where TRequest : IProtoRequest where TResponse : IProtoResponse
{
    public Task<List<TResponse>> GetAll();

    public Task<TResponse> GetById(TId id);

    public Task<TResponse> Add(TRequest request);

    public Task<TResponse> Update(TId id, TRequest request);

    public Task Delete(TId id);

    // New query methods
    public Task<List<TResponse>> GetByField(string fieldName, object value);

    public Task<List<TResponse>> GetByFields(Dictionary<string, object> criteria);

    public Task<List<TResponse>> GetByWhere(WhereRequest request);

    public Task<TResponse> GetFirstByField(string fieldName, object value);

    public Task<bool> ExistsByField(string fieldName, object value);
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

    public virtual async Task<List<TResponse>> GetAll()
        => await GetManyAsync<TResponse>("");

    public virtual async Task<TResponse> GetById(TId id)
        => await GetAsync<TResponse>($"{id}");


    public virtual async Task<TResponse> Add(TRequest request)
        => await PostAsync<TRequest, TResponse>("", request);

    public virtual async Task<TResponse> Update(TId id, TRequest request)
        => await PutAsync<TRequest, TResponse>($"{id}", request);

    public virtual async Task Delete(TId id)
        => await DeleteAsync($"{id}");

    public virtual async Task<List<TResponse>> GetByField(string fieldName, object value)
        => await GetManyAsync<TResponse>($"by-field/{fieldName}/{value}");

    public virtual async Task<List<TResponse>> GetByFields(Dictionary<string, object> criteria)
        => await PostAsync<Dictionary<string, object>, List<TResponse>>("by-fields", criteria);

    public virtual async Task<List<TResponse>> GetByWhere(WhereRequest request)
        => await PostAsync<WhereRequest, List<TResponse>>("by-where", request);

    public virtual async Task<TResponse> GetFirstByField(string fieldName, object value)
        => await GetAsync<TResponse>($"first-by-field/{fieldName}/{value}");

    public virtual async Task<bool> ExistsByField(string fieldName, object value)
        => await GetAsync<bool>($"exists-by-field/{fieldName}/{value}");
}
