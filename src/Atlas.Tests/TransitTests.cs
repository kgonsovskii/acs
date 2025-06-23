using Microsoft.VisualStudio.TestTools.UnitTesting;
using Infra;
using SevenSeals.Tss.Shared.Tests.Base;

namespace SevenSeals.Tss.Atlas;

[TestClass]
public class AtlasTestsTransits : TestStorageBase<Transit, Transit, Guid, ITransitClient, AtlasTestFactory, Startup>
{
    protected override Guid GetId(Transit response)
    {
        return response.Id;
    }

    protected override Transit CreateRequest()
    {
        var transit = new Transit();
        transit.FillWithRandomValues();
        transit.SpotId = null;
        return transit;
    }
}
