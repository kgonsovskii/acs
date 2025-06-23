using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public interface IActorStorage : IBaseStorage<Member, Guid>;

public class ActorStorage: BaseStorage<Member, Guid>, IActorStorage
{
    public ActorStorage(Settings settings, ILogger<ActorStorage> logger) : base(settings, logger)
    {
    }
}
