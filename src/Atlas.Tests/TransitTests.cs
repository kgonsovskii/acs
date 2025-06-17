using Microsoft.VisualStudio.TestTools.UnitTesting;
using Shared.Tests;

namespace SevenSeals.Tss.Atlas;

[TestClass]
public class AtlasTestsTransits : TestStorageBase<TransitRequest, TransitResponse, Guid, TransitClient, AtlasTestFactory, Startup>
{
    protected override Guid GetId(TransitResponse response)
    {
        return response.Id;
    }
}
