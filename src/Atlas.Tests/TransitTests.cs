using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

[TestClass]
public class AtlasTestsTransits : TestStorageBase<Transit, Transit, Guid, ITransitClient, AtlasTestFactory, Startup>
{
    protected override Guid GetId(Transit response)
    {
        return response.Id;
    }
}
