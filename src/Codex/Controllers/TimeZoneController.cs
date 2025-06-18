using System.Diagnostics.CodeAnalysis;
using SevenSeals.Tss.Codex.Storage;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Codex.Controllers;

public class TimeZoneController : ProtoStorageController<TimeZoneRule, Guid, ITimeZoneStorage, TimeZoneRule, TimeZoneRule>
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public TimeZoneController(ITimeZoneStorage storage, Settings settings) : base(storage, settings)
    {
    }
}
