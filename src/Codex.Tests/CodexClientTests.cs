using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SevenSeals.Tss.Codex;

[TestClass]
public class CodexClientTests : CodexTestsBase<CodexClient>
{
    [TestMethod]
    public async Task GetRoutes_ShouldReturnRoutes()
    {
        using var client = OpenClient();
        var route1 = await client.CreateRouteAsync(new Route
        {
            Name = "Route 1",
            FromZoneId = Guid.NewGuid(),
            ToZoneId = Guid.NewGuid()
        });
        var route2 = await client.CreateRouteAsync(new Route
        {
            Name = "Route 2",
            FromZoneId = Guid.NewGuid(),
            ToZoneId = Guid.NewGuid()
        });

        var result = await client.GetRoutesAsync();

        result.Should().Contain(r => r.Id == route1.Id && r.Name == route1.Name);
        result.Should().Contain(r => r.Id == route2.Id && r.Name == route2.Name);
    }

    [TestMethod]
    public async Task CreateRoute_ShouldReturnCreatedRoute()
    {
        using var client = OpenClient();
        var route = new Route
        {
            Name = "New Route",
            FromZoneId = Guid.NewGuid(),
            ToZoneId = Guid.NewGuid()
        };

        var result = await client.CreateRouteAsync(route);

        result.Id.Should().NotBe(Guid.Empty);
        result.Name.Should().Be(route.Name);
        result.FromZoneId.Should().Be(route.FromZoneId);
        result.ToZoneId.Should().Be(route.ToZoneId);
    }

    [TestMethod]
    public async Task GetTimeZoneRules_ShouldReturnRules()
    {
        using var client = OpenClient();
        var rule1 = await client.CreateTimeZoneRuleAsync(new TimeZoneRule
        {
            Name = "Rule 1",
            DayOfWeek = DayOfWeek.Monday,
            StartTime = TimeSpan.FromHours(9),
            EndTime = TimeSpan.FromHours(17)
        });
        var rule2 = await client.CreateTimeZoneRuleAsync(new TimeZoneRule
        {
            Name = "Rule 2",
            DayOfWeek = DayOfWeek.Tuesday,
            StartTime = TimeSpan.FromHours(10),
            EndTime = TimeSpan.FromHours(18)
        });

        var result = await client.GetTimeZoneRulesAsync();

        result.Should().Contain(r => r.Id == rule1.Id && r.Name == rule1.Name);
        result.Should().Contain(r => r.Id == rule2.Id && r.Name == rule2.Name);
    }

    [TestMethod]
    public async Task GetAccessLevels_ShouldReturnAccessLevels()
    {
        using var client = OpenClient();
        var level1 = await client.CreateAccessLevelAsync(new AccessLevel
        {
            Name = "Level 1",
            Priority = 1
        });
        var level2 = await client.CreateAccessLevelAsync(new AccessLevel
        {
            Name = "Level 2",
            Priority = 2
        });

        var result = await client.GetAccessLevelsAsync();

        result.Should().Contain(l => l.Id == level1.Id && l.Name == level1.Name);
        result.Should().Contain(l => l.Id == level2.Id && l.Name == level2.Name);
    }
}
