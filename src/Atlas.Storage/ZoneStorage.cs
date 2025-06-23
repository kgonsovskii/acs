using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public interface IZoneStorage : IBaseStorage<Zone, Guid>;

public class ZoneStorage: BaseStorage<Zone, Guid>, IZoneStorage
{
    public ZoneStorage(Settings settings, ILogger<ZoneStorage> logger) : base(settings, logger)
    {
    }
} 