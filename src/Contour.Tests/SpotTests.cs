using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

[TestClass]
public class SpotTests : TestStorageBase<Spot, Spot, Guid, ISpotClient, ContourTestFactory, Startup>
{
    protected override Guid GetId(Spot response)
    {
        return response.Id;
    }
}
