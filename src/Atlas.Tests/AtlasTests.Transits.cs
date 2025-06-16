using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SevenSeals.Tss.Atlas;

[TestClass]
public class AtlasTestsTransits : AtlasTestsBase<AtlasClient>
{
    [TestMethod]
    public async Task CreateAndGetTransit()
    {
        using var client = OpenClient();

        var zone1 = await client.CreateZone(new ZoneRequest { Name = "Zone 1", Type = ZoneTypeEnum.Building });
        var zone2 = await client.CreateZone(new ZoneRequest { Name = "Zone 2", Type = ZoneTypeEnum.Building });

        var createRequest = new TransitRequest
        {
            FromZoneId = zone1.Id,
            ToZoneId = zone2.Id,
            IsBidirectional = true
        };
        var createdTransit = await client.CreateTransit(createRequest);
        createdTransit.Should().NotBeNull();
        createdTransit.FromZoneId.Should().Be(zone1.Id);
        createdTransit.ToZoneId.Should().Be(zone2.Id);
        createdTransit.IsBidirectional.Should().BeTrue();

        var retrievedTransit = await client.GetTransit(createdTransit.Id);
        retrievedTransit.Should().NotBeNull();
        retrievedTransit.Id.Should().Be(createdTransit.Id);
        retrievedTransit.FromZoneId.Should().Be(zone1.Id);
        retrievedTransit.ToZoneId.Should().Be(zone2.Id);
        retrievedTransit.IsBidirectional.Should().BeTrue();
    }

    [TestMethod]
    public async Task UpdateTransit()
    {
        using var client = OpenClient();

        var zone1 = await client.CreateZone(new ZoneRequest { Name = "Zone 1", Type = ZoneTypeEnum.Building });
        var zone2 = await client.CreateZone(new ZoneRequest { Name = "Zone 2", Type = ZoneTypeEnum.Building });
        var zone3 = await client.CreateZone(new ZoneRequest { Name = "Zone 3", Type = ZoneTypeEnum.Building });

        var createRequest = new TransitRequest
        {
            FromZoneId = zone1.Id,
            ToZoneId = zone2.Id,
            IsBidirectional = true
        };
        var createdTransit = await client.CreateTransit(createRequest);

        var updateRequest = new TransitRequest
        {
            FromZoneId = zone1.Id,
            ToZoneId = zone3.Id,
            IsBidirectional = false
        };
        var updatedTransit = await client.UpdateTransit(createdTransit.Id, updateRequest);
        updatedTransit.Should().NotBeNull();
        updatedTransit.Id.Should().Be(createdTransit.Id);
        updatedTransit.FromZoneId.Should().Be(zone1.Id);
        updatedTransit.ToZoneId.Should().Be(zone3.Id);
        updatedTransit.IsBidirectional.Should().BeFalse();
    }

    [TestMethod]
    public async Task DeleteTransit()
    {
        using var client = OpenClient();

        var zone1 = await client.CreateZone(new ZoneRequest { Name = "Zone 1", Type = ZoneTypeEnum.Building });
        var zone2 = await client.CreateZone(new ZoneRequest { Name = "Zone 2", Type = ZoneTypeEnum.Building });

        var createRequest = new TransitRequest
        {
            FromZoneId = zone1.Id,
            ToZoneId = zone2.Id,
            IsBidirectional = true
        };
        var createdTransit = await client.CreateTransit(createRequest);

        await client.DeleteTransit(createdTransit.Id);

        var transits = await client.GetAllTransits();
        transits.Should().NotContain(t => t.Id == createdTransit.Id);
    }
}
