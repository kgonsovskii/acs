using System.Net;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Logging;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoStorageClient: ProtoClient
{
    protected ProtoStorageClient(HttpClient httpClient, string agent, ILogger logger) : base(httpClient, agent, logger)
    {
    }

    protected ProtoStorageClient(string baseUri, string agent, Action<string> logAction) : base(baseUri, agent, logAction)
    {
    }
}
