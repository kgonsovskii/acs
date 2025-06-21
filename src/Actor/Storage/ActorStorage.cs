using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor.Storage;

public interface IActorStorage : IBaseStorage<Member, Guid>;

public class ActorStorage: BaseStorage<Member, Guid>, IActorStorage
{
    public ActorStorage(Settings settings, ILogger<ActorStorage> logger) : base(settings, logger)
    {
    }
}
