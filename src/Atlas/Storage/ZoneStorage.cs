using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas.Storage;

public interface IZoneStorage : IBaseStorage<Zone, Guid>
{

}

public class ZoneStorage: BaseJsonStorage<Zone, Guid>, IZoneStorage
{
    public ZoneStorage(Settings settings, ILogger<ZoneStorage> logger) : base(settings, logger)
    {
    }
}
