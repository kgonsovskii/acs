using SevenSeals.Tss.Actor.Storage;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor.Controllers;

public class KeyController : ProtoStorageController<Key, Guid, IKeyStorage, Key, Key>
{
    public KeyController(IKeyStorage storage, Settings settings) : base(storage, settings)
    {
    }
}
