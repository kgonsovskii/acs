using Microsoft.VisualStudio.TestTools.UnitTesting;
using Shared.Tests;

namespace SevenSeals.Tss.Atlas;

[TestClass]
public class AtlasTestsTransits : TestStorageBase<Transit, Transit, Guid, ITransitClient, AtlasTestFactory, Startup>
{
    protected override Guid GetId(Transit response)
    {
        return response.Id;
    }
}
