using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SevenSeals.Tss.Atlas;

[TestClass]
public class AtlasTestsZones : AtlasTestsBase<AtlasClient>
{
    [TestMethod]
    public async Task GetAllZones()
    {
        using var client = OpenClient();
        var zones = await client.GetAllZones();
        zones.Should().NotBeNull();
    }

    [TestMethod]
    public async Task CreateAndGetZone()
    {
        using var client = OpenClient();

        var createRequest = new ZoneRequest
        {
            Name = "Test Zone",
            Type = ZoneTypeEnum.Building
        };
        var createdZone = await client.CreateZone(createRequest);
        createdZone.Should().NotBeNull();
        createdZone.Name.Should().Be("Test Zone");
        createdZone.Type.Should().Be(ZoneTypeEnum.Building);

        // Get the created zone
        var retrievedZone = await client.GetZone(createdZone.Id);
        retrievedZone.Should().NotBeNull();
        retrievedZone.Id.Should().Be(createdZone.Id);
        retrievedZone.Name.Should().Be("Test Zone");
        retrievedZone.Type.Should().Be(ZoneTypeEnum.Building);
    }

    [TestMethod]
    public async Task UpdateZone()
    {
        using var client = OpenClient();

        // Create a zone first
        var createRequest = new ZoneRequest
        {
            Name = "Original Name",
            Type = ZoneTypeEnum.Building
        };
        var createdZone = await client.CreateZone(createRequest);

        // Update the zone
        var updateRequest = new ZoneRequest
        {
            Name = "Updated Name",
            Type = ZoneTypeEnum.Room
        };
        var updatedZone = await client.UpdateZone(createdZone.Id, updateRequest);
        updatedZone.Should().NotBeNull();
        updatedZone.Id.Should().Be(createdZone.Id);
        updatedZone.Name.Should().Be("Updated Name");
        updatedZone.Type.Should().Be(ZoneTypeEnum.Room);
    }

    [TestMethod]
    public async Task DeleteZone()
    {
        using var client = OpenClient();

        // Create a zone first
        var createRequest = new ZoneRequest
        {
            Name = "To Delete",
            Type = ZoneTypeEnum.Building
        };
        var createdZone = await client.CreateZone(createRequest);

        // Delete the zone
        await client.DeleteZone(createdZone.Id);

        // Verify it's deleted
        var zones = await client.GetAllZones();
        zones.Should().NotContain(z => z.Id == createdZone.Id);
    }

    [TestMethod]
    public async Task CreateAndGetTransit()
    {
        using var client = OpenClient();

        // Create two zones first
        var zone1 = await client.CreateZone(new ZoneRequest { Name = "Zone 1", Type = ZoneTypeEnum.Building });
        var zone2 = await client.CreateZone(new ZoneRequest { Name = "Zone 2", Type = ZoneTypeEnum.Building });

        // Create a transit between them
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

        // Get the created transit
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

        // Create two zones first
        var zone1 = await client.CreateZone(new ZoneRequest { Name = "Zone 1", Type = ZoneTypeEnum.Building });
        var zone2 = await client.CreateZone(new ZoneRequest { Name = "Zone 2", Type = ZoneTypeEnum.Building });
        var zone3 = await client.CreateZone(new ZoneRequest { Name = "Zone 3", Type = ZoneTypeEnum.Building });

        // Create a transit
        var createRequest = new TransitRequest
        {
            FromZoneId = zone1.Id,
            ToZoneId = zone2.Id,
            IsBidirectional = true
        };
        var createdTransit = await client.CreateTransit(createRequest);

        // Update the transit
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

        // Create two zones first
        var zone1 = await client.CreateZone(new ZoneRequest { Name = "Zone 1", Type = ZoneTypeEnum.Building });
        var zone2 = await client.CreateZone(new ZoneRequest { Name = "Zone 2", Type = ZoneTypeEnum.Building });

        // Create a transit
        var createRequest = new TransitRequest
        {
            FromZoneId = zone1.Id,
            ToZoneId = zone2.Id,
            IsBidirectional = true
        };
        var createdTransit = await client.CreateTransit(createRequest);

        // Delete the transit
        await client.DeleteTransit(createdTransit.Id);

        // Verify it's deleted
        var transits = await client.GetAllTransits();
        transits.Should().NotContain(t => t.Id == createdTransit.Id);
    }
}
