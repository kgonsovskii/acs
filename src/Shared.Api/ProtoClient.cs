using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Logging;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoClient: IDisposable
{
    private readonly HttpClient _httpClient;
    private readonly string _apiEndpoint;
    private readonly ILogger? _logger;
    private readonly Action<string>? _loggerAction;

    protected ProtoClient(string baseUri, ILogger logger)
    {
        _httpClient = new HttpClient
        {
            BaseAddress = new Uri(AppendTrailingSlash(baseUri))
        };
        _apiEndpoint = baseUri;
        _logger = logger;
    }

    protected ProtoClient(HttpClient httpClient, Action<string> loggerAction)
    {
        _httpClient = httpClient ?? throw new ArgumentNullException(nameof(httpClient));
        _loggerAction = loggerAction ?? throw new ArgumentNullException(nameof(loggerAction));
        _apiEndpoint = "http://localhost/api/";
    }

    protected virtual void Log(string message)
    {
        if (_loggerAction != null)
            _loggerAction(message);
        if (_logger != null)
            _logger.LogInformation(message);
    }

    public void SetBearerToken(string token)
    {
        _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
    }

    public void AddDefaultHeader(string name, string value)
    {
        _httpClient.DefaultRequestHeaders.Add(name, value);
    }

    public async Task<TResponse> GetAsync<TRequest, TResponse>(string action, TRequest request) where TRequest : RequestBase where TResponse : ResponseBase
    {
        var url = BuildUrlFromRequest(action, request);
        Log($"GET {url}");

        var response = await _httpClient.GetAsync(url);
        return await HandleResponse<TResponse>(response);
    }

    public async Task<TResponse> PostAsync<TRequest, TResponse>(string action, TRequest request) where TRequest : RequestBase where TResponse : ResponseBase
    {
        var url = BuildUrlFromRequest(action, request);
        var json = JsonSerializer.Serialize(request);
        var content = new StringContent(json, Encoding.UTF8, "application/json");

        Log($"POST {url} BODY: {json}");

        var response = await _httpClient.PostAsync(url, content);
        return await HandleResponse<TResponse>(response);
    }

    public async Task<TResponse> PutAsync<TRequest, TResponse>(string action, TRequest request) where TRequest : RequestBase where TResponse : ResponseBase
    {
        var url = BuildUrlFromRequest(action, request);
        var json = JsonSerializer.Serialize(request);
        var content = new StringContent(json, Encoding.UTF8, "application/json");

        Log($"PUT {url} BODY: {json}");

        var response = await _httpClient.PutAsync(url, content);
        return await HandleResponse<TResponse>(response);
    }

    public async Task<TResponse> DeleteAsync<TRequest, TResponse>(string action, TRequest request) where TRequest : RequestBase where TResponse : ResponseBase
    {
        var url = BuildUrlFromRequest(action, request);
        Log($"DELETE {url}");

        var response = await _httpClient.DeleteAsync(url);
        return await HandleResponse<TResponse>(response);
    }

    private Uri BuildUrlFromRequest<TRequest>(string action, TRequest request) where TRequest : RequestBase
    {
        var baseUri = new Uri(_apiEndpoint);
        var fullUri = new Uri(baseUri, action);
        return fullUri;
    }

    private async Task<TResponse> HandleResponse<TResponse>(HttpResponseMessage response) where TResponse : ResponseBase
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
