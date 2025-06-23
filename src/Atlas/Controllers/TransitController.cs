using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas.Controllers;

public class TransitController : ProtoStorageController<Transit, Guid, ITransitStorage, Transit, Transit>
{
    public TransitController(ITransitStorage storage, Settings settings) : base(storage, settings)
    {
    }
}
