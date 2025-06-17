using System.Net;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoClient : ProtoClient<ClientOptions>
{
    public ProtoClient(HttpClient httpClient, Settings settings, IOptions<ClientOptions> options, ILogger<ProtoClient<ClientOptions>> logger) : base(httpClient, settings, options, logger)
    {
    }

    protected ProtoClient(HttpClient httpClient, string agent, ILogger logger) : base(httpClient, agent, logger)
    {
    }

    protected ProtoClient(string baseUri, string agent, Action<string> logAction) : base(baseUri, agent, logAction)
    {
    }
}

public abstract class ProtoClient<TOptions>: IDisposable where TOptions : ClientOptions
{
    protected virtual string Route =>  GetType().Name.Replace("Client", "");

    private readonly string _agent;
    private readonly HttpClient _httpClient;
    private readonly ILogger? _logger;
    private readonly Action<string>? _loggerAction;

    public ProtoClient(HttpClient httpClient, Settings settings, IOptions<TOptions> options, ILogger<ProtoClient<TOptions>> logger)
    {
        _agent = settings.Agent;
        _logger = logger;
        _httpClient = httpClient;
        httpClient.BaseAddress = new Uri(options.Value.BaseUri);
    }


    protected ProtoClient(HttpClient httpClient, string agent, ILogger logger)
    {
        _httpClient = httpClient;
        _agent = agent;
        _logger = logger;
    }

    protected ProtoClient(string baseUri, string agent, Action<string> logAction)
    {
        _agent = agent;
        _httpClient = new HttpClient() { BaseAddress = new Uri(baseUri) };
        _loggerAction = logAction;
    }

    protected virtual void Log(string message)
    {
        _logger?.LogInformation(message);
        _loggerAction?.Invoke(message);
    }

    public void SetBearerToken(string token)
    {
        _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
    }

    public void AddDefaultHeader(string name, string value)
    {
        _httpClient.DefaultRequestHeaders.Add(name, value);
    }

    protected async Task<TResponse> GetAsync<TResponse>(string action)  where TResponse : IProtoResponse
    {
        var url = BuildUrl(action);
        Log($"GET {url}");

        var response = await _httpClient.GetAsync(url);
        return await HandleResponse<TResponse>(response);
    }

    protected async Task<TResponse> PostAsync<TRequest, TResponse>(string action, TRequest request)
        where TRequest : IProtoRequest where TResponse : IProtoResponse
    {
        return await RequestAsync<TRequest, TResponse>(WebRequestMethods.Http.Post, action, request);
    }

    protected async Task<TResponse> PutAsync<TRequest, TResponse>(string action, TRequest request)
        where TRequest : IProtoRequest where TResponse : IProtoResponse
    {
        return await RequestAsync<TRequest, TResponse>(WebRequestMethods.Http.Put, action, request);
    }

    protected async Task DeleteAsync(string action)
    {
        var url = BuildUrl(action);
        Log($"DELETE {url}");

        var response = await _httpClient.DeleteAsync(url);
        response.EnsureSuccessStatusCode();
    }

    private async Task<TResponse> GetAsync<TRequest, TResponse>(string action, TRequest request)
        where TRequest : IProtoRequest where TResponse : IProtoResponse
    {
        return await RequestAsync<TRequest, TResponse>(WebRequestMethods.Http.Get, action, request);
    }

    private async Task<TResponse> RequestAsync<TRequest, TResponse>(string verb, string action, TRequest request)
        where TRequest : IProtoRequest where TResponse : IProtoResponse
    {
        var url = BuildUrlFromRequest(action, request);
        var traceId = Guid.NewGuid().ToString();
        var hash = request.GetProtoHash();

        var json = request.Serialize();
        var content = new StringContent(json, Encoding.UTF8, "application/json");

        content.Headers.Add(ProtoHeaders.TraceId, traceId);
        content.Headers.Add(ProtoHeaders.Agent, _agent);
        content.Headers.Add(ProtoHeaders.Chop, request.Headers.Chop.ToString());
        content.Headers.Add(ProtoHeaders.Hash, hash.ToString());

        Log($"{verb} {url} BODY: {json}");

        HttpResponseMessage response;
        switch (verb)
        {
            case WebRequestMethods.Http.Get:
                response = await _httpClient.GetAsync(url);
                break;
            case WebRequestMethods.Http.Post:
                response = await _httpClient.PostAsync(url, content);
                break;
            case WebRequestMethods.Http.Put:
                response = await _httpClient.PutAsync(url, content);
                break;
            default:
                throw new ArgumentException($"Unsupported HTTP verb: {verb}");
        }

        return await HandleResponse<TResponse>(response);
    }

    private Uri BuildUrl(string action)
    {
        var full = $"api/{Route}/{action}";
        return new Uri(_httpClient.BaseAddress!, full);
    }

    private Uri BuildUrlFromRequest<TRequest>(string action, TRequest request)
        where TRequest : IProtoRequest
    {
        var full = $"api/{Route}/{action}";
        var fullUri = new Uri(_httpClient.BaseAddress!, full);
        return fullUri;
    }

    private async Task<TResponse> HandleResponse<TResponse>(HttpResponseMessage response)  where TResponse : IProtoResponse
    {
        var content = await response.Content.ReadAsStringAsync();
        Log($"Response: {response.StatusCode} BODY: {content}");

        response.EnsureSuccessStatusCode();

        var result = JsonSerializer.Deserialize<TResponse>(content, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        }) ?? throw new InvalidOperationException("Response body is null");

        if (response.Headers.TryGetValues(ProtoHeaders.TraceId, out var traceId))
            result.Headers.TraceId = traceId.First();
        if (response.Headers.TryGetValues(ProtoHeaders.Agent, out var agent))
            result.Headers.Agent = agent.First();
        if (response.Headers.TryGetValues(ProtoHeaders.Chop, out var chop) && int.TryParse(chop.First(), out var chopValue))
            result.Headers.Chop = chopValue;
        if (response.Headers.TryGetValues(ProtoHeaders.Hash, out var hash) && int.TryParse(hash.First(), out var hashValue))
            result.Headers.Hash = hashValue;

        return result;
    }

    private static string AppendTrailingSlash(string uri) =>
        uri.EndsWith("/") ? uri : uri + "/";

    public virtual void Dispose()
    {
        GC.SuppressFinalize(this);
    }
}
