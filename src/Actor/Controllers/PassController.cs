using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor.Controllers;

public class PassController : ProtoStorageController<Pass, Guid, IKeyStorage, Pass, Pass>
{
    public PassController(IKeyStorage storage, Settings settings) : base(storage, settings)
    {
    }
}
