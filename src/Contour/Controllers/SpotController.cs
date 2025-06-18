using SevenSeals.Tss.Contour.Storage;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Controllers;

public class SpotController: ProtoStorageController<Spot, Guid, ISpotStorage, Spot, Spot>
{
    public SpotController(ISpotStorage storage, Settings settings) : base(storage, settings)
    {
    }
}
