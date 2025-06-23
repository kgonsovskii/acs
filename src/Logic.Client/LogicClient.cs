using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;
using SevenSeals.Tss.Logic.Api;

namespace SevenSeals.Tss.Logic;

public interface ILogicClient: IProtoClient
{
    public Task<List<PassTouchedClientEvent>> OnClientEvent(ProtoRequest request);
    event EventHandler<PassTouchedClientEvent> OnPassTouched;
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

    public async Task<List<PassTouchedClientEvent>> OnClientEvent(ProtoRequest request)
    {
        return await PutAsync<ProtoRequest, List<PassTouchedClientEvent>>(nameof(OnClientEvent), request);
    }

    public event EventHandler<PassTouchedClientEvent>? OnPassTouched;
}
