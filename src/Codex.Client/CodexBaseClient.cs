using System.Net.Http.Json;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Codex;

public abstract class CodexBaseClient : ProtoClient
{
    public CodexBaseClient(HttpClient httpClient, Settings settings, IOptions<CodexClientOptions> options, ILogger<CodexBaseClient> logger) : base(httpClient, settings.Agent, logger)
    {
        httpClient.BaseAddress = new Uri(options.Value.BaseUri);
    }
}
