using Microsoft.VisualStudio.TestTools.UnitTesting;
using Infra;
using SevenSeals.Tss.Shared.Tests.Base;
using Microsoft.Extensions.DependencyInjection;

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
        // Ensure FK constraints are satisfied: create two zones first
        using var scope = Factory.Services.CreateScope();
        var zoneClient = scope.ServiceProvider.GetRequiredService<IZoneClient>();

        var fromZone = new Zone();
        fromZone.FillWithRandomValues();
        fromZone.ParentId = null; // root zone is fine
        var createdFromZone = zoneClient.Add(fromZone).GetAwaiter().GetResult();

        var toZone = new Zone();
        toZone.FillWithRandomValues();
        toZone.ParentId = null;
        var createdToZone = zoneClient.Add(toZone).GetAwaiter().GetResult();

        var transit = new Transit();
        transit.FillWithRandomValues();
        transit.SpotId = null;
        transit.FromZoneId = createdFromZone.Id;
        transit.ToZoneId = createdToZone.Id;
        return transit;
    }
}
