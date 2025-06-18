using SevenSeals.Tss.Actor.Storage;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor.Controllers;

public class ActorController : ProtoStorageController<Actor, Guid, IActorStorage, Actor, Actor>
{
    public ActorController(IActorStorage storage, Settings settings) : base(storage, settings)
    {
    }
}
