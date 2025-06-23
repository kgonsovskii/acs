using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Logic.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Logic;

public interface ILogicCallbackClient: IProtoClient
{
    public Task<CallBackResponse> OnContourCallBack(CallBackRequest request);
}

public class LogicCallbackClient: ProtoClient, ILogicCallbackClient
{
    public LogicCallbackClient(HttpClient httpClient, Settings settings, IOptions<LogicClientOptions> options, ILogger<ProtoClient<ClientOptions>> logger) : base(httpClient, settings, options, logger)
    {
    }

    public LogicCallbackClient(HttpClient httpClient, string agent, ILogger logger) : base(httpClient, agent, logger)
    {
    }

    public LogicCallbackClient(string baseUri, string agent, Action<string> logAction) : base(baseUri, agent, logAction)
    {
    }

    public async Task<CallBackResponse> OnContourCallBack(CallBackRequest request)
    {
        return await PutAsync<CallBackRequest, CallBackResponse>(nameof(OnContourCallBack), request);
    }
}
