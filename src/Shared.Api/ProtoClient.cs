using System.Net;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Logging;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoClient: IDisposable
{
    protected virtual string Route =>  GetType().Name.Replace("Client", "");

    private readonly HttpClient _httpClient;
    private readonly ILogger? _logger;
    private readonly Action<string>? _loggerAction;

    protected ProtoClient(HttpClient httpClient, ILogger logger)
    {
        _httpClient = httpClient;

        _logger = logger;
    }

    protected ProtoClient(string baseUri, Action<string> logAction)
    {
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

    protected async Task<TResponse> PostAsync<TRequest, TResponse>(string action, TRequest request)
        where TRequest : RequestBase where TResponse : ResponseBase
    {
        return await RequestAsync<TRequest, TResponse>(WebRequestMethods.Http.Post, action, request);
    }

    private async Task<TResponse> GetAsync<TRequest, TResponse>(string action, TRequest request)
        where TRequest : RequestBase where TResponse : ResponseBase
    {
        return await RequestAsync<TRequest, TResponse>(WebRequestMethods.Http.Get, action, request);
    }

    private async Task<TResponse> RequestAsync<TRequest, TResponse>(string verb, string action, TRequest request) where TRequest : RequestBase where TResponse : ResponseBase
    {
        var url = BuildUrlFromRequest(action, request);
        request.TraceId = Guid.NewGuid().ToString();
        request.Hash = request.GetHash();
        var response = await PostAsync<TRequest, TResponse>(url, request);

        // if (response.Hash != response.GetHash())
        // {
        //     throw new ApiException($"Hash mismatch for command {action} , traceId: {request.TraceId}");
        // }
        //
        // if (response.TraceId != request.TraceId)
        // {
        //     throw new ApiException($"TraceId mismatch for command {action} , traceId: {request.TraceId}");
        // }

        return response;
    }

    private async Task<TResponse> PostAsync<TRequest, TResponse>(Uri url, TRequest request) where TRequest : RequestBase where TResponse : ResponseBase
    {
        var json = JsonSerializer.Serialize(request);
        var content = new StringContent(json, Encoding.UTF8, "application/json");

        Log($"POST {url} BODY: {json}");

        var response = await _httpClient.PostAsync(url, content);
        return await HandleResponse<TResponse>(response);
    }

    private Uri BuildUrlFromRequest<TRequest>(string action, TRequest request) where TRequest : RequestBase
    {
        var full = $"api/{Route}/{action}";
        var fullUri = new Uri(_httpClient.BaseAddress!, full);
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
