using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Text.RegularExpressions;
using SevenSeals.Tss.Shared;
using Atlas.Component;

#pragma warning disable CS8618 // Non-nullable field must contain a non-null value when exiting constructor. Consider adding the 'required' modifier or declaring as nullable.

namespace SevenSeals.Tss.Atlas;

[TestClass]
public class AtlasPlotterTests
{
    private Map _map;
    private AtlasPlotter _plotter;
    private string _testOutputPath;

    [TestInitialize]
    public void Setup()
    {
        // Create test output directory
        _testOutputPath = Path.Combine(TestContext.TestRunResultsDirectory!, "../../..");
        _testOutputPath = Path.GetFullPath(_testOutputPath);
        if (!Directory.Exists(_testOutputPath))
            Directory.CreateDirectory(_testOutputPath);

        var externalArea = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Внешний мир",
 Type = ZoneType.ExternalArea
        };

        var building = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Семь Печатей HQ",
            Type = ZoneType.Building,
            Hint = "Феодосийская, дом 1"
        };

        var floor2 = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Второй этаж",
            Type = ZoneType.Floor,
            ParentId = building.Id,
        };

        var сoridor = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Коридор",
            Type = ZoneType.Corridor,
            ParentId = floor2.Id,
        };

        var sklad = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Склад",
            Type = ZoneType.Room,
            ParentId = floor2.Id,
        };

        var buhgalter = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Главный бухгалтер",
            Type = ZoneType.Room,
            ParentId = floor2.Id,
        };

        var classroom = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Учительская",
            Type = ZoneType.Room,
            ParentId = floor2.Id,
        };

        var coders = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Программисты",
            Type = ZoneType.Room,
            ParentId = floor2.Id,
        };

        // Create transits
        var transits = new List<Transit>
        {
            new()
            {
                Id = Guid.NewGuid(),
                Name = "Вход с улицы",
                FromZoneId = externalArea.Id,
                ToZoneId = building.Id,
                IsBidirectional = true
            },
            new()
            {
                Id = Guid.NewGuid(),
                Name = "Главный вход",
                FromZoneId = floor2.Id,
                ToZoneId = сoridor.Id,
                IsBidirectional = true
            },
            new()
            {
                Id = Guid.NewGuid(),
                Name = "Вход в склад",
                FromZoneId = floor2.Id,
                ToZoneId = sklad.Id,
                IsBidirectional = true
            },
            new()
            {
                Id = Guid.NewGuid(),
                Name = "Дверь",
                FromZoneId = сoridor.Id,
                ToZoneId = buhgalter.Id,
                IsBidirectional = true
            },
            new()
            {
                Id = Guid.NewGuid(),
                Name = "office.sevenseals.ru:5087",
                FromZoneId = сoridor.Id,
                ToZoneId = classroom.Id,
                IsBidirectional = true
            },
            new()
            {
                Id = Guid.NewGuid(),
                Name = "office.sevenseals.ru:5086",
                FromZoneId = сoridor.Id,
                ToZoneId = coders.Id,
                IsBidirectional = true
            }
        };

        _map = new Map
        {
            Zones = [building, floor2, сoridor, sklad, buhgalter, classroom, coders, externalArea],
            Transits = transits
        };

        _map.Zones.SerializeToFile("Zone.json");
        _map.Transits.SerializeToFile("Transit.json");

        _plotter = new AtlasPlotter(_map);
    }

    private static string GetZoneId(Zone zone)
    {
        // Get clean name, only replace problematic characters for PlantUML
        var cleanName = zone.Name ?? string.Empty;
        
        // Replace only characters that are problematic in PlantUML IDs
        // Allow spaces, hyphens, dots, but replace other special chars
        var sanitizedName = Regex.Replace(cleanName, @"[^\p{L}\p{N}\s\-\._]", "");
        
        // Replace spaces with underscores for PlantUML compatibility
        sanitizedName = sanitizedName.Replace(" ", "_");
        
        // Remove leading/trailing underscores
        sanitizedName = sanitizedName.Trim('_');
        
        // If name is empty, use a simple fallback
        if (string.IsNullOrEmpty(sanitizedName))
        {
            return $"zone_{zone.Id.ToString().Replace("-", "").Substring(0, 8)}";
        }
        
        return $"zone_{sanitizedName}";
    }

    private static string GetZoneColor(ZoneType type)
    {
        return type switch
        {
            ZoneType.Building => "#FFE4E1", // Misty Rose
            ZoneType.Floor => "#E6E6FA",    // Lavender
            ZoneType.Room => "#F0FFF0",     // Honeydew
            ZoneType.Corridor => "#F5F5DC", // Beige
            ZoneType.Lobby => "#FFDAB9",    // Peach Puff
            ZoneType.Elevator => "#D8BFD8", // Thistle
            ZoneType.Staircase => "#F0F8FF",// Alice Blue
            ZoneType.Parking => "#E0FFFF",  // Light Cyan
            ZoneType.ExternalArea => "#F5F5F5", // White Smoke
            _ => "#FFFFFF"                      // White
        };
    }

    private static string GetZoneDisplayName(Zone zone)
    {
        if (!string.IsNullOrEmpty(zone.Name) && !string.IsNullOrEmpty(zone.Hint))
        {
            return zone.Name + " (" + zone.Hint + ")";
        }
        if (!string.IsNullOrEmpty(zone.Name))
        {
            return zone.Name;
        }
        if (!string.IsNullOrEmpty(zone.Hint))
        {
            return zone.Hint;
        }
        return $"{zone.GetType().Name} ({zone.Type})";
    }

    public TestContext TestContext { get; set; }

    [TestMethod]
    public void GeneratePlantUml_ShouldGenerateValidPlantUml()
    {
        // Act
        var plantUml = _plotter.GeneratePlantUml();
        File.WriteAllText(Path.Combine(_testOutputPath, "plant.plantuml"), plantUml);
    }

    private static string GetTransitLabel(Transit transit)
    {
        if (!string.IsNullOrEmpty(transit.Name))
        {
            return transit.Name;
        }
        if (!string.IsNullOrEmpty(transit.Hint))
        {
            return transit.Hint;
        }
        return transit.GetType().Name; // Fallback to ClassName if no Name or Hint
    }

    [TestMethod]
    public void GeneratePlantUmlUrl_ShouldGenerateValidUrl()
    {
        var url = _plotter.GeneratePlantUmlUrl();
        TestContext.WriteLine(url);
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleEmptyMap()
    {
        // Arrange
        var emptyMap = new Map();
        var plotter = new AtlasPlotter(emptyMap);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        plantUml.Should().StartWith("@startuml");
        plantUml.Should().EndWith("@enduml");
        plantUml.Should().NotContain("rectangle");
        plantUml.Should().NotContain("Transit");
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleSingleZone()
    {
        // Arrange
        var singleZoneMap = new Map
        {
            Zones =
            [
                new()
                {
                    Id = Guid.NewGuid(),
                    Name = "Test Zone",
                    Type = ZoneType.Room
                }
            ]
        };
        var plotter = new AtlasPlotter(singleZoneMap);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        plantUml.Should().Contain("Test Zone");
        plantUml.Should().NotContain("Room"); // Should not contain the type as we are using Name/Hint
        plantUml.Should().NotContain("Transit");
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleUnidirectionalTransit()
    {
        // Arrange
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone A", Type = ZoneType.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone B", Type = ZoneType.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, IsBidirectional = false };

        var map = new Map
        {
            Zones = [fromZone, toZone],
            Transits = [transit]
        };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        plantUml.Should().Contain($"{GetZoneId(fromZone)} --> {GetZoneId(toZone)} : Transit");
        plantUml.Should().NotContain($"{GetZoneId(fromZone)} <--> {GetZoneId(toZone)} : Transit");
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleBidirectionalTransit()
    {
        // Arrange
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone C", Type = ZoneType.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone D", Type = ZoneType.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, IsBidirectional = true };

        var map = new Map
        {
            Zones = [fromZone, toZone],
            Transits = [transit]
        };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        plantUml.Should().Contain($"{GetZoneId(fromZone)} <--> {GetZoneId(toZone)} : Transit");
        plantUml.Should().NotContain($"{GetZoneId(fromZone)} --> {GetZoneId(toZone)} : Transit");
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldIncludeAllZoneTypes()
    {
        // Arrange
        var allZones = new List<Zone>();
        foreach (ZoneType type in Enum.GetValues(typeof(ZoneType)))
        {
            allZones.Add(new Zone { Id = Guid.NewGuid(), Name = $"Zone {type}", Type = type });
        }
        var map = new Map { Zones = allZones };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        foreach (var zone in allZones)
        {
            var zoneId = GetZoneId(zone);
            var zoneDisplayName = GetZoneDisplayName(zone);

            var expectedDefinition = "";
            if (zone.Type == ZoneType.Building || zone.Type == ZoneType.Floor)
            {
                expectedDefinition = $"package \"{zoneDisplayName}\" as {zoneId}";
            }
            else
            {
                expectedDefinition = $"component \"{zoneDisplayName}\" as {zoneId}";
            }
            plantUml.Should().Contain(expectedDefinition);
        }
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleSpecialCharactersInNames()
    {
        // Arrange
        var zoneWithSpecialChars = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Zone with Spaces & Symbols!@#",
            Type = ZoneType.Room,
            Hint = "A zone with a hint and special characters."
        };
        var map = new Map { Zones = [zoneWithSpecialChars] };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        var zoneId = GetZoneId(zoneWithSpecialChars);
        plantUml.Should().Contain($"component \"Zone with Spaces & Symbols!@#\" as {zoneId}");
        plantUml.Should().Contain($"note left of {zoneId} : A zone with a hint and special characters.");
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleHintOnlyZone()
    {
        // Arrange
        var hintOnlyZone = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "",
            Type = ZoneType.Room,
            Hint = "This is a hint only zone."
        };
        var map = new Map { Zones = [hintOnlyZone] };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        var zoneId = GetZoneId(hintOnlyZone);
        plantUml.Should().Contain($"component \"\" as {zoneId}");
        plantUml.Should().Contain($"note left of {zoneId} : This is a hint only zone.");
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleFallbackZoneName()
    {
        // Arrange
        var fallbackZone = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "",
            Type = ZoneType.Room,
            Hint = ""
        };
        var map = new Map { Zones = [fallbackZone] };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        var zoneId = GetZoneId(fallbackZone);
        plantUml.Should().Contain($"component \"\" as {zoneId}");
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleTransitWithHint()
    {
        // Arrange
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone A", Type = ZoneType.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone B", Type = ZoneType.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, Hint = "Custom Transit Hint", IsBidirectional = false };

        var map = new Map
        {
            Zones = [fromZone, toZone],
            Transits = [transit]
        };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        plantUml.Should().Contain($"{GetZoneId(fromZone)} --> {GetZoneId(toZone)} : Custom Transit Hint");
        plantUml.Should().NotContain($"{GetZoneId(fromZone)} <--> {GetZoneId(toZone)} : Custom Transit Hint");
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleTransitWithName()
    {
        // Arrange
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone X", Type = ZoneType.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone Y", Type = ZoneType.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, Name = "Named Transit", IsBidirectional = false };

        var map = new Map
        {
            Zones = [fromZone, toZone],
            Transits = [transit]
        };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        plantUml.Should().Contain($"{GetZoneId(fromZone)} --> {GetZoneId(toZone)} : Named Transit");
        plantUml.Should().NotContain($"{GetZoneId(fromZone)} <--> {GetZoneId(toZone)} : Named Transit");
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleTransitFallbackLabel()
    {
        // Arrange
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone M", Type = ZoneType.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone N", Type = ZoneType.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, Name = "", Hint = "", IsBidirectional = false };

        var map = new Map
        {
            Zones = [fromZone, toZone],
            Transits = [transit]
        };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        plantUml.Should().Contain($"{GetZoneId(fromZone)} --> {GetZoneId(toZone)} : Transit");
        plantUml.Should().NotContain($"{GetZoneId(fromZone)} <--> {GetZoneId(toZone)} : Transit");
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleBidirectionalTransitWithHint()
    {
        // Arrange
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone P", Type = ZoneType.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone Q", Type = ZoneType.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, Hint = "Bidirectional Hint", IsBidirectional = true };

        var map = new Map
        {
            Zones = [fromZone, toZone],
            Transits = [transit]
        };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        plantUml.Should().Contain($"{GetZoneId(fromZone)} <--> {GetZoneId(toZone)} : Bidirectional Hint");
        plantUml.Should().NotContain($"{GetZoneId(fromZone)} --> {GetZoneId(toZone)} : Bidirectional Hint");
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleBidirectionalTransitWithName()
    {
        // Arrange
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone R", Type = ZoneType.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone S", Type = ZoneType.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, Name = "Bidirectional Name", IsBidirectional = true };

        var map = new Map
        {
            Zones = [fromZone, toZone],
            Transits = [transit]
        };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        plantUml.Should().Contain($"{GetZoneId(fromZone)} <--> {GetZoneId(toZone)} : Bidirectional Name");
        plantUml.Should().NotContain($"{GetZoneId(fromZone)} --> {GetZoneId(toZone)} : Bidirectional Name");
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleBidirectionalTransitFallbackLabel()
    {
        // Arrange
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone U", Type = ZoneType.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone V", Type = ZoneType.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, Name = "", Hint = "", IsBidirectional = true };

        var map = new Map
        {
            Zones = [fromZone, toZone],
            Transits = [transit]
        };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        plantUml.Should().Contain($"{GetZoneId(fromZone)} <--> {GetZoneId(toZone)} : Transit");
        plantUml.Should().NotContain($"{GetZoneId(fromZone)} --> {GetZoneId(toZone)} : Transit");
    }

    [TestMethod]
    public void GeneratePlantUml_WithOrderedFloors_ShouldOrderCorrectly()
    {
        // Arrange - Create data structure similar to initdata files
        var externalArea = new Zone
        {
            Id = Guid.Parse("7b335e42-2c34-455b-8041-86111c50aac1"),
            Name = "Outside World",
            Type = ZoneType.ExternalArea,
            Order = 1,
            IsActive = true
        };

        var building = new Zone
        {
            Id = Guid.Parse("f9918759-9a99-40e9-9fbb-e06d57e07677"),
            Name = "Seven Seals HQ",
            Type = ZoneType.Building,
            ParentId = externalArea.Id,
            Order = 2,
            IsActive = true
        };

        var firstFloor = new Zone
        {
            Id = Guid.Parse("74ea2417-a157-4852-b91a-4646aa35e779"),
            Name = "1-st floor",
            Type = ZoneType.Floor,
            ParentId = building.Id,
            Order = 3,
            IsActive = true
        };

        var secondFloor = new Zone
        {
            Id = Guid.Parse("4ba26900-7e80-4bb2-b916-38a24dd6a997"),
            Name = "Second floor",
            Type = ZoneType.Floor,
            ParentId = building.Id,
            Order = 4,
            IsActive = true
        };

        var corridor = new Zone
        {
            Id = Guid.Parse("26cf4711-9880-4a57-bcc5-6da0569df512"),
            Name = "Corridor",
            Type = ZoneType.Corridor,
            ParentId = secondFloor.Id,
            Order = 1,
            IsActive = true
        };

        var zones = new List<Zone> { externalArea, building, firstFloor, secondFloor, corridor };

        var transit1 = new Transit
        {
            Id = Guid.Parse("6102b44c-e253-479d-8dda-2c8bada596e1"),
            Name = "Vhod s ulizi",
            FromZoneId = externalArea.Id,
            ToZoneId = building.Id,
            IsBidirectional = true,
            Order = 1,
            IsActive = true
        };

        var transit2 = new Transit
        {
            Id = Guid.Parse("a1b2c3d4-e5f6-7890-abcd-ef1234567890"),
            Name = "Vhod na 1 etaj",
            FromZoneId = building.Id,
            ToZoneId = firstFloor.Id,
            IsBidirectional = true,
            Order = 2,
            IsActive = true
        };

        var transit3 = new Transit
        {
            Id = Guid.Parse("b6ecb955-d757-4b03-8ae8-45c6fcc8efc7"),
            Name = "Vhod na 2 etaj",
            FromZoneId = building.Id,
            ToZoneId = secondFloor.Id,
            IsBidirectional = true,
            Order = 3,
            IsActive = true
        };

        var transits = new List<Transit> { transit1, transit2, transit3 };

        var map = new Map { Zones = zones, Transits = transits };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();
        File.WriteAllText(Path.Combine(_testOutputPath, "ordered_floors.plantuml"), plantUml);

        // Assert - Verify that the PlantUML contains the correct ordering
        plantUml.Should().Contain("Vhod na 1 etaj");
        plantUml.Should().Contain("Vhod na 2 etaj");
        
        // Find the positions of the transit lines
        var lines = plantUml.Split('\n');
        var transit1Index = Array.FindIndex(lines, line => line.Contains("Vhod na 1 etaj"));
        var transit2Index = Array.FindIndex(lines, line => line.Contains("Vhod na 2 etaj"));
        
        // The first floor transit should come before the second floor transit
        transit1Index.Should().BeLessThan(transit2Index, "First floor transit should appear before second floor transit");
    }
}
