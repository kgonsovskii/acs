using Microsoft.VisualStudio.TestTools.UnitTesting;
using Shared.Tests;

namespace SevenSeals.Tss.Codex;

[TestClass]
public class TimeZoneTests : TestStorageBase<TimeZoneRule, TimeZoneRule, Guid, ITimeZoneClient, CodexTestFactory, Startup>
{
    protected override Guid GetId(TimeZoneRule response)
    {
        return response.Id;
    }
}
