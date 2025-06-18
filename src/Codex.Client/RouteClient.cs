using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Codex;

public interface IRouteClient: IProtoStorageClient<RouteRule, RouteRule, Guid>;

public class RouteClient : ProtoStorageClient<RouteRule, RouteRule, Guid>, IRouteClient
{
    public RouteClient(HttpClient httpClient, Settings settings, IOptions<CodexClientOptions> options,
        ILogger<RouteClient> logger) : base(httpClient, settings, options, logger)
    {

    }
}
