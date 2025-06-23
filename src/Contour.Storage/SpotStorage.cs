using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public interface ISpotStorage : IBaseStorage<Spot, Guid>
{

}

public class SpotStorage : BaseStorage<Spot, Guid>, ISpotStorage
{
    public SpotStorage(Settings settings, ILogger<SpotStorage> logger) : base(settings, logger)
    {
    }
} 