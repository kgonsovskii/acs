using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;
using SevenSeals.Tss.Logic.Api;

namespace SevenSeals.Tss.Logic;

public interface ILogicClient: IProtoClient
{
    event EventHandler<PassTouchedResponse> PassTouched;

    public Task<PassTouchedResponse> FirePassTouched(PassTouchedRequest request);
}

public class LogicClient: ProtoClient, ILogicClient
{
    public LogicClient(HttpClient httpClient, Settings settings, IOptions<LogicClientOptions> options, ILogger<ProtoClient<ClientOptions>> logger) : base(httpClient, settings, options, logger)
    {
    }

    public LogicClient(HttpClient httpClient, string agent, ILogger logger) : base(httpClient, agent, logger)
    {
    }

    public LogicClient(string baseUri, string agent, Action<string> logAction) : base(baseUri, agent, logAction)
    {
    }

    public event EventHandler<PassTouchedResponse>? PassTouched;

    public async Task<PassTouchedResponse> FirePassTouched(PassTouchedRequest request)
    {
        var response = await PutAsync<PassTouchedRequest, PassTouchedResponse>(nameof(FirePassTouched), request);
        PassTouched?.Invoke(this, response);
        return response;
    }
}
