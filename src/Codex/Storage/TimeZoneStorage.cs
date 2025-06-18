using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Codex.Storage;

public interface ITimeZoneStorage : IBaseStorage<TimeZoneRule, Guid>;

public class TimeZoneStorage: BaseStorage<TimeZoneRule, Guid>, ITimeZoneStorage
{
    public TimeZoneStorage(Settings settings, ILogger<TimeZoneStorage> logger) : base(settings, logger)
    {
    }
}
