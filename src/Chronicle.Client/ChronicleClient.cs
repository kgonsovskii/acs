using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Chronicle;

public interface IChronicleClient: IProtoClient
{
}

public class ChronicleClient: ProtoClient, IChronicleClient
{
    public ChronicleClient(HttpClient httpClient, Settings settings, IOptions<ChronicleClientOptions> options, ILogger<ChronicleClient> logger) : base(httpClient, settings, options, logger)
    {

    }
}
