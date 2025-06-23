using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared.Tests.Base;

namespace SevenSeals.Tss.Atlas;

[TestClass]
public class ZonesTests : TestStorageBase<Zone, Zone, Guid,  IZoneClient, AtlasTestFactory, Startup>
{
   protected override Guid GetId(Zone response)
   {
       return response.Id;
   }
}
