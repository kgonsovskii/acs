using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public interface IPassClient : IProtoStorageClient<Pass, Pass, Guid>
{
    public Task<Pass> GetByKeyNumber(string keyNumber);
}

public class PassClient : ProtoStorageClient<Pass, Pass, Guid>, IPassClient
{
    public PassClient(HttpClient httpClient, Settings settings, IOptions<ActorClientOptions> options,
        ILogger<PassClient> logger) : base(httpClient, settings, options, logger)
    {

    }

    public virtual async Task<Pass> GetByKeyNumber(string keyNumber)
        => (await GetByField("keyNumber", keyNumber)).First();
}
