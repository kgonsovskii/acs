using System;
using System.Threading.Tasks;
using SevenSeals.Tss.Codex;
using SevenSeals.Tss.Codex.Client;
using SevenSeals.Tss.Shared;
using Xunit;

namespace SevenSeals.Tss.Codex.Tests;

public class CodexClientTests : TestBase
{
    private readonly CodexClient _codexClient;

    public CodexClientTests()
    {
        _codexClient = GetClient<CodexClient>();
    }

    [Fact]
    public async Task GetRoutes_ShouldReturnRoutes()
    {
        // Arrange
        var route1 = await _codexClient.CreateRouteAsync(new Route 
        { 
            Name = "Route 1",
            FromZoneId = Guid.NewGuid(),
            ToZoneId = Guid.NewGuid()
        });
        var route2 = await _codexClient.CreateRouteAsync(new Route 
        { 
            Name = "Route 2",
            FromZoneId = Guid.NewGuid(),
            ToZoneId = Guid.NewGuid()
        });

        // Act
        var result = await _codexClient.GetRoutesAsync();

        // Assert
        Assert.Contains(result, r => r.Id == route1.Id && r.Name == route1.Name);
        Assert.Contains(result, r => r.Id == route2.Id && r.Name == route2.Name);
    }

    [Fact]
    public async Task CreateRoute_ShouldReturnCreatedRoute()
    {
        // Arrange
        var route = new Route 
        { 
            Name = "New Route",
            FromZoneId = Guid.NewGuid(),
            ToZoneId = Guid.NewGuid()
        };

        // Act
        var result = await _codexClient.CreateRouteAsync(route);

        // Assert
        Assert.NotEqual(Guid.Empty, result.Id);
        Assert.Equal(route.Name, result.Name);
        Assert.Equal(route.FromZoneId, result.FromZoneId);
        Assert.Equal(route.ToZoneId, result.ToZoneId);
    }

    [Fact]
    public async Task GetTimeZoneRules_ShouldReturnRules()
    {
        // Arrange
        var rule1 = await _codexClient.CreateTimeZoneRuleAsync(new TimeZoneRule 
        { 
            Name = "Rule 1",
            DayOfWeek = DayOfWeek.Monday,
            StartTime = TimeSpan.FromHours(9),
            EndTime = TimeSpan.FromHours(17)
        });
        var rule2 = await _codexClient.CreateTimeZoneRuleAsync(new TimeZoneRule 
        { 
            Name = "Rule 2",
            DayOfWeek = DayOfWeek.Tuesday,
            StartTime = TimeSpan.FromHours(10),
            EndTime = TimeSpan.FromHours(18)
        });

        // Act
        var result = await _codexClient.GetTimeZoneRulesAsync();

        // Assert
        Assert.Contains(result, r => r.Id == rule1.Id && r.Name == rule1.Name);
        Assert.Contains(result, r => r.Id == rule2.Id && r.Name == rule2.Name);
    }

    [Fact]
    public async Task GetAccessLevels_ShouldReturnAccessLevels()
    {
        // Arrange
        var level1 = await _codexClient.CreateAccessLevelAsync(new AccessLevel 
        { 
            Name = "Level 1",
            Priority = 1
        });
        var level2 = await _codexClient.CreateAccessLevelAsync(new AccessLevel 
        { 
            Name = "Level 2",
            Priority = 2
        });

        // Act
        var result = await _codexClient.GetAccessLevelsAsync();

        // Assert
        Assert.Contains(result, l => l.Id == level1.Id && l.Name == level1.Name);
        Assert.Contains(result, l => l.Id == level2.Id && l.Name == level2.Name);
    }
} 