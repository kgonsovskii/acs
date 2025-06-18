using SevenSeals.Tss.Codex.Storage;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Codex.Controllers;

public class TimeZoneController : ProtoStorageController<TimeZoneRule, Guid, ITimeZoneStorage, TimeZoneRule, TimeZoneRule>
{
    public TimeZoneController(ITimeZoneStorage storage, Settings settings) : base(storage, settings)
    {
    }
}
