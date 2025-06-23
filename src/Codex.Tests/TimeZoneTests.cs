using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared.Tests.Base;

namespace SevenSeals.Tss.Codex;

[TestClass]
public class TimeZoneTests : TestStorageBase<TimeZoneRule, TimeZoneRule, Guid, ITimeZoneClient, CodexTestFactory, Startup>
{
    protected override Guid GetId(TimeZoneRule response)
    {
        return response.Id;
    }
}
