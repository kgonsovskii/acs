using System.Diagnostics.CodeAnalysis;
using System.Net;
using System.Net.Http.Headers;
using System.Text;
using Infra;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace SevenSeals.Tss.Shared;

public interface IProtoClient : IDisposable
{
    public ClientOptions Options { get; }
}

public abstract class ProtoClient : ProtoClient<ClientOptions>, IProtoClient
{
    [SuppressMessage("ReSharper", "PublicConstructorInAbstractClass")]
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

[SuppressMessage("ReSharper", "UnusedTypeParameter")]
public interface IProtoClient<TOptions> : IDisposable where TOptions : ClientOptions;

public abstract class ProtoClient<TOptions> : IProtoClient<TOptions> where TOptions : ClientOptions
{
    public TOptions Options { get; }
    protected virtual string Route => GetType().Name.Replace("Client", "");

    protected string Agent { get; }

    private readonly HttpClient _httpClient;
    private readonly ILogger? _logger;
    private readonly Action<string>? _loggerAction;

    [SuppressMessage("ReSharper", "PublicConstructorInAbstractClass")]
    public ProtoClient(HttpClient httpClient, Settings settings, IOptions<TOptions> options,
        ILogger<ProtoClient<TOptions>> logger)
    {
        if (string.IsNullOrEmpty(options.Value.BaseUri))
        {
            throw new ArgumentNullException(typeof(TOptions).FullName);
        }
        Agent = settings.Agent;
        _logger = logger;
        _httpClient = httpClient;
        Options = options.Value;
        httpClient.BaseAddress = new Uri(options.Value.BaseUri);
    }

    protected ProtoClient(HttpClient httpClient, string agent, ILogger logger)
    {
        _httpClient = httpClient;
        Agent = agent;
        _logger = logger;
    }

    protected ProtoClient(string baseUri, string agent, Action<string> logAction)
    {
        Agent = agent;
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

    protected async Task<TResponse> GetAsync<TResponse>(string action) where TResponse : notnull
    {
        return await RequestAsync<TResponse>(WebRequestMethods.Http.Get, action);
    }

    protected async Task<List<TResponse>> GetManyAsync<TResponse>(string action) where TResponse : IProtoResponse
    {
        return await RequestAsync<List<TResponse>>(WebRequestMethods.Http.Get, action);
    }

    protected async Task<TResponse> PostAsync<TRequest, TResponse>(string action, TRequest request)
         where TResponse : notnull
    {
        return await RequestAsync<TRequest, TResponse>(WebRequestMethods.Http.Post, action, request);
    }

    protected async Task<TResponse> PutAsync<TRequest, TResponse>(string action, TRequest request)
        where TRequest : IProtoRequest
    {
        return await RequestAsync<TRequest, TResponse>(WebRequestMethods.Http.Put, action, request);
    }

    protected async Task DeleteAsync(string action)
    {
        var traceId = TraceId.NextTraceId();
        await RequestAsync("DELETE", action, traceId, null, null);
    }

    private async Task<TResponse> RequestAsync<TRequest, TResponse>(string verb, string action, TRequest request)
        where TRequest: notnull where TResponse : notnull
    {
        return await RequestAsync<TResponse>(verb, action, request);
    }

    private async Task<TResponse> RequestAsync<TResponse>(string verb, string action)
    {
        return await RequestAsync<TResponse>(verb, action, null, null);
    }

    private async Task<TResponse> RequestAsync<TResponse>(string verb, string action, object request)
        where TResponse : notnull
    {
        var hash = request.GetProtoHash();
        var json = request.Serialize();
        return await RequestAsync<TResponse>(verb, action, json, hash);
    }

    private async Task<TResponse> RequestAsync<TResponse>(string verb, string action, string? json, int? hash)
    {
        var traceId = TraceId.NextTraceId();
        var response = await RequestAsync(verb, action, traceId, json, hash);
        return await HandleResponse<TResponse>(response, traceId, hash);
    }

    protected virtual Dictionary<string, string> BuildHeaders(int traceId)
    {
        var headers = new Dictionary<string, string>
        {
            [ProtoHeaders.TraceId] = traceId.ToString(),
            [ProtoHeaders.Agent] = Agent,
            [ProtoHeaders.Chop] = "1",
            [ProtoHeaders.Version] = AppVersion.Version
        };
        return headers;
    }

    private async Task<HttpResponseMessage> RequestAsync(string verb, string action, int traceId, string? json,
        int? hash)
    {
        var url = BuildUrlFromRequest(action);

        var headers = BuildHeaders(traceId);

        HttpRequestMessage? message = null;
        StringContent? content = null;
        if (json != null)
        {
            content = new StringContent(json, Encoding.UTF8, "application/json");
            foreach (var kv in headers)
                content.Headers.Add(kv.Key, kv.Value);
            content.Headers.Add(ProtoHeaders.Hash, hash!.ToString());
        }
        else
        {
            message = verb switch
            {
                WebRequestMethods.Http.Get => new HttpRequestMessage(HttpMethod.Get, url),
                "DELETE" => new HttpRequestMessage(HttpMethod.Delete, url),
                _ => throw new NotImplementedException()
            };

            foreach (var kv in headers)
                message.Headers.Add(kv.Key, kv.Value);
        }

        var response = verb switch
        {
            WebRequestMethods.Http.Get => await _httpClient.SendAsync(message!),
            WebRequestMethods.Http.Post => await _httpClient.PostAsync(url, content!),
            WebRequestMethods.Http.Put => await _httpClient.PutAsync(url, content!),
            "DELETE" => await _httpClient.SendAsync(message!),
            _ => throw new ArgumentException($"Unsupported HTTP verb: {verb}")
        };
        return response;
    }


    private Uri BuildUrlFromRequest(string action)
    {
        var full = $"api/{Route}/{action}";
        var fullUri = new Uri(_httpClient.BaseAddress!, full);
        return fullUri;
    }

    protected virtual async Task<TResponse> HandleResponse<TResponse>(HttpResponseMessage response, int traceId, int? hash)
    {
        var content = await response.Content.ReadAsStringAsync();

        response.EnsureSuccessStatusCode();

        if (response.Headers.TryGetValues(ProtoHeaders.TraceId, out var tracIds))
        {
            var receivedTraceId = int.Parse(tracIds.First());
            if (traceId != receivedTraceId)
            {
                throw new InvalidOperationException($"TraceId mismatch: {traceId}");
            }
        }
        else
        {
            throw new InvalidOperationException($"No {ProtoHeaders.TraceId} header found");
        }

        var result = content.Deserialize<TResponse>()!;

        return result;
    }

    public virtual void Dispose()
    {
        GC.SuppressFinalize(this);
    }
}
