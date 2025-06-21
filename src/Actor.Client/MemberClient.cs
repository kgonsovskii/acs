using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public interface IMemberClient: IProtoStorageClient<Member, Member, Guid>;

public class MemberClient : ProtoStorageClient<Member, Member, Guid>, IMemberClient
{
    public MemberClient(HttpClient httpClient, Settings settings, IOptions<ActorClientOptions> options,
        ILogger<MemberClient> logger) : base(httpClient, settings, options, logger)
    {

    }
}
