using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Text.RegularExpressions;
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
 Type = ZoneTypeEnum.ExternalArea
        };

        var building = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Семь Печатей HQ",
            Type = ZoneTypeEnum.Building,
            Hint = "Феодосийская, дом 1"
        };

        var floor2 = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Второй этаж",
            Type = ZoneTypeEnum.Floor,
            ParentId = building.Id,
        };

        var сoridor = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Коридор",
            Type = ZoneTypeEnum.Corridor,
            ParentId = floor2.Id,
        };

        var sklad = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Склад 1111",
            Type = ZoneTypeEnum.Room,
            ParentId = floor2.Id,
        };

        var buhgalter = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Главный бухгалтер",
            Type = ZoneTypeEnum.Room,
            ParentId = floor2.Id,
        };

        var classroom = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Учительская",
            Type = ZoneTypeEnum.Room,
            ParentId = floor2.Id,
        };

        var coders = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "Программисты",
            Type = ZoneTypeEnum.Room,
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

        _plotter = new AtlasPlotter(_map);
    }

    private static string GetZoneId(Zone zone)
    {
        // Sanitize zone name to create a valid PlantUML ID, allowing Unicode letters and numbers
        var sanitizedName = Regex.Replace(zone.Name, @"[^\p{L}\p{N}_]", "_");
        var uniqueSuffix = zone.Id.ToString().Replace("-", "_").Substring(0, 8); // Use a portion of GUID for uniqueness

        // If sanitized name is empty or very generic, ensure uniqueness with the GUID suffix
        if (string.IsNullOrEmpty(sanitizedName) || sanitizedName == "_")
        {
            return $"zone_{uniqueSuffix}";
        }
        return $"zone_{sanitizedName}_{uniqueSuffix}";
    }

    private static string GetZoneColor(ZoneTypeEnum type)
    {
        return type switch
        {
            ZoneTypeEnum.Building => "#FFE4E1", // Misty Rose
            ZoneTypeEnum.Floor => "#E6E6FA",    // Lavender
            ZoneTypeEnum.Room => "#F0FFF0",     // Honeydew
            ZoneTypeEnum.Corridor => "#F5F5DC", // Beige
            ZoneTypeEnum.Lobby => "#FFDAB9",    // Peach Puff
            ZoneTypeEnum.Elevator => "#D8BFD8", // Thistle
            ZoneTypeEnum.Staircase => "#F0F8FF",// Alice Blue
            ZoneTypeEnum.Parking => "#E0FFFF",  // Light Cyan
            ZoneTypeEnum.ExternalArea => "#F5F5F5", // White Smoke
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
        System.IO.File.WriteAllText(Path.Combine(_testOutputPath, "plant.plantuml"), plantUml);
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
            Zones = new List<Zone>
            {
                new()
                {
                    Id = Guid.NewGuid(),
                    Name = "Test Zone",
                    Type = ZoneTypeEnum.Room
                }
            }
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
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone A", Type = ZoneTypeEnum.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone B", Type = ZoneTypeEnum.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, IsBidirectional = false };

        var map = new Map
        {
            Zones = new List<Zone> { fromZone, toZone },
            Transits = new List<Transit> { transit }
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
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone C", Type = ZoneTypeEnum.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone D", Type = ZoneTypeEnum.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, IsBidirectional = true };

        var map = new Map
        {
            Zones = new List<Zone> { fromZone, toZone },
            Transits = new List<Transit> { transit }
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
        foreach (ZoneTypeEnum type in Enum.GetValues(typeof(ZoneTypeEnum)))
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
            if (zone.Type == ZoneTypeEnum.Building || zone.Type == ZoneTypeEnum.Floor)
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
            Type = ZoneTypeEnum.Room,
            Hint = "A zone with a hint and special characters."
        };
        var map = new Map { Zones = new List<Zone> { zoneWithSpecialChars } };
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
            Type = ZoneTypeEnum.Room,
            Hint = "This is a hint only zone."
        };
        var map = new Map { Zones = new List<Zone> { hintOnlyZone } };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        var zoneId = GetZoneId(hintOnlyZone);
        plantUml.Should().Contain($"component \"This is a hint only zone.\" as {zoneId}");
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
            Type = ZoneTypeEnum.Room,
            Hint = ""
        };
        var map = new Map { Zones = new List<Zone> { fallbackZone } };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        var zoneId = GetZoneId(fallbackZone);
        plantUml.Should().Contain($"component \"Zone (Room)\" as {zoneId}");
    }

    [TestMethod]
    public void GeneratePlantUml_ShouldHandleTransitWithHint()
    {
        // Arrange
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone A", Type = ZoneTypeEnum.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone B", Type = ZoneTypeEnum.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, Hint = "Custom Transit Hint", IsBidirectional = false };

        var map = new Map
        {
            Zones = new List<Zone> { fromZone, toZone },
            Transits = new List<Transit> { transit }
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
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone X", Type = ZoneTypeEnum.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone Y", Type = ZoneTypeEnum.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, Name = "Named Transit", IsBidirectional = false };

        var map = new Map
        {
            Zones = new List<Zone> { fromZone, toZone },
            Transits = new List<Transit> { transit }
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
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone M", Type = ZoneTypeEnum.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone N", Type = ZoneTypeEnum.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, Name = "", Hint = "", IsBidirectional = false };

        var map = new Map
        {
            Zones = new List<Zone> { fromZone, toZone },
            Transits = new List<Transit> { transit }
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
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone P", Type = ZoneTypeEnum.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone Q", Type = ZoneTypeEnum.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, Hint = "Bidirectional Hint", IsBidirectional = true };

        var map = new Map
        {
            Zones = new List<Zone> { fromZone, toZone },
            Transits = new List<Transit> { transit }
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
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone R", Type = ZoneTypeEnum.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone S", Type = ZoneTypeEnum.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, Name = "Bidirectional Name", IsBidirectional = true };

        var map = new Map
        {
            Zones = new List<Zone> { fromZone, toZone },
            Transits = new List<Transit> { transit }
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
        var fromZone = new Zone { Id = Guid.NewGuid(), Name = "Zone U", Type = ZoneTypeEnum.Room };
        var toZone = new Zone { Id = Guid.NewGuid(), Name = "Zone V", Type = ZoneTypeEnum.Room };
        var transit = new Transit { Id = Guid.NewGuid(), FromZoneId = fromZone.Id, ToZoneId = toZone.Id, Name = "", Hint = "", IsBidirectional = true };

        var map = new Map
        {
            Zones = new List<Zone> { fromZone, toZone },
            Transits = new List<Transit> { transit }
        };
        var plotter = new AtlasPlotter(map);

        // Act
        var plantUml = plotter.GeneratePlantUml();

        // Assert
        plantUml.Should().Contain($"{GetZoneId(fromZone)} <--> {GetZoneId(toZone)} : Transit");
        plantUml.Should().NotContain($"{GetZoneId(fromZone)} --> {GetZoneId(toZone)} : Transit");
    }
}
