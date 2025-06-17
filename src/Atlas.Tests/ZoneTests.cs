using Microsoft.VisualStudio.TestTools.UnitTesting;
using Shared.Tests;

namespace SevenSeals.Tss.Atlas;

[TestClass]
public class ZonesTests : TestStorageBase<ZoneRequest, ZoneResponse, Guid,  ZoneClient, AtlasTestFactory, Startup>
{
   protected override Guid GetId(ZoneResponse response)
   {
       return response.Id;
   }
}
