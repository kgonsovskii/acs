using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Codex;

public interface ITimeZoneClient: IProtoStorageClient<TimeZoneRule, TimeZoneRule, Guid>;

public class TimeZoneClient : ProtoStorageClient<TimeZoneRule, TimeZoneRule, Guid>, ITimeZoneClient
{
    public TimeZoneClient(HttpClient httpClient, Settings settings, IOptions<CodexClientOptions> options,
        ILogger<TimeZoneClient> logger) : base(httpClient, settings, options, logger)
    {

    }
}
