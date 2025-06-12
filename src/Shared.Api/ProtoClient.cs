using System.Net;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Logging;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoClient: IDisposable
{
    protected virtual string Route =>  GetType().Name.Replace("Client", "");

    private readonly string _agent;
    private readonly HttpClient _httpClient;
    private readonly ILogger? _logger;
    private readonly Action<string>? _loggerAction;

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

    protected async Task<TResponse> GetAsync<TResponse>(string action)
    {
        var url = BuildUrl(action);
        Log($"GET {url}");

        var response = await _httpClient.GetAsync(url);
        return await HandleResponse<TResponse>(response);
    }

    protected async Task<TResponse> PostAsync<TRequest, TResponse>(string action, TRequest request)
        where TRequest : RequestBase where TResponse : ResponseBase
    {
        return await RequestAsync<TRequest, TResponse>(WebRequestMethods.Http.Post, action, request);
    }

    protected async Task<TResponse> PutAsync<TRequest, TResponse>(string action, TRequest request)
        where TRequest : RequestBase where TResponse : ResponseBase
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
        where TRequest : RequestBase where TResponse : ResponseBase
    {
        return await RequestAsync<TRequest, TResponse>(WebRequestMethods.Http.Get, action, request);
    }

    private async Task<TResponse> RequestAsync<TRequest, TResponse>(string verb, string action, TRequest request) 
        where TRequest : RequestBase where TResponse : ResponseBase
    {
        var url = BuildUrlFromRequest(action, request);
        request.TraceId = Guid.NewGuid().ToString();
        request.Agent = _agent;
        request.Hash = request.GetHash();

        var json = request.Serialize();
        var content = new StringContent(json, Encoding.UTF8, "application/json");
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
        where TRequest : RequestBase
    {
        var full = $"api/{Route}/{action}";
        var fullUri = new Uri(_httpClient.BaseAddress!, full);
        return fullUri;
    }

    private async Task<TResponse> HandleResponse<TResponse>(HttpResponseMessage response)
    {
        var content = await response.Content.ReadAsStringAsync();
        Log($"Response: {response.StatusCode} BODY: {content}");

        response.EnsureSuccessStatusCode();

        return JsonSerializer.Deserialize<TResponse>(content, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        }) ?? throw new InvalidOperationException("Response body is null");
    }

    private static string AppendTrailingSlash(string uri) =>
        uri.EndsWith("/") ? uri : uri + "/";

    public virtual void Dispose()
    {
        GC.SuppressFinalize(this);
    }
}
