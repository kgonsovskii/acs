using System.Diagnostics.CodeAnalysis;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor.Storage;

public interface IActorStorage : IBaseStorage<Actor, Guid>
{

}

public class ActorStorage: BaseStorage<Actor, Guid>, IActorStorage
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public ActorStorage(Settings settings, ILogger<ActorStorage> logger) : base(settings, logger)
    {
    }
}
