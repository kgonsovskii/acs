using System.Text.Json;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public class AtlasStorage
{
    private readonly string _dataPath;
    private readonly ILogger<AtlasStorage> _logger;
    private readonly AtlasMap _map = new AtlasMap();

    public AtlasStorage(Settings settings, ILogger<AtlasStorage> logger)
    {
        _logger = logger;
        _dataPath = settings.DataDir;
        Directory.CreateDirectory(_dataPath);
        LoadData();
    }

    private void LoadData()
    {
        try
        {
            var filePath = Path.Combine(_dataPath, "atlas.json");
            if (File.Exists(filePath))
            {
                var json = File.ReadAllText(filePath);
                var loadedMap = JsonSerializer.Deserialize<AtlasMap>(json);
                if (loadedMap != null)
                {
                    _map.Zones = loadedMap.Zones;
                    _map.Transits = loadedMap.Transits;
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error loading Atlas data");
            _map.Zones = new List<Zone>();
            _map.Transits = new List<Transit>();
        }
    }

    private void SaveData()
    {
        try
        {
            var filePath = Path.Combine(_dataPath, "atlas.json");
            var json = JsonSerializer.Serialize(_map, new JsonSerializerOptions { WriteIndented = true });
            File.WriteAllText(filePath, json);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error saving Atlas data");
            throw;
        }
    }

    #region Zones

    public IEnumerable<Zone> GetAllZones()
    {
        return _map.Zones;
    }

    public Zone? GetZone(Guid id)
    {
        return _map.Zones.FirstOrDefault(z => z.Id == id);
    }

    public void CreateZone(Zone zone)
    {
        _map.Zones.Add(zone);
        SaveData();
    }

    public void UpdateZone(Zone zone)
    {
        var index = _map.Zones.FindIndex(z => z.Id == zone.Id);
        if (index != -1)
        {
            _map.Zones[index] = zone;
            SaveData();
        }
    }

    public void DeleteZone(Guid id)
    {
        _map.Zones.RemoveAll(z => z.Id == id);
        SaveData();
    }

    #endregion

    #region Transits

    public IEnumerable<Transit> GetAllTransits()
    {
        return _map.Transits;
    }

    public Transit? GetTransit(Guid id)
    {
        return _map.Transits.FirstOrDefault(t => t.Id == id);
    }

    public void CreateTransit(Transit transit)
    {
        _map.Transits.Add(transit);
        SaveData();
    }

    public void UpdateTransit(Transit transit)
    {
        var index = _map.Transits.FindIndex(t => t.Id == transit.Id);
        if (index != -1)
        {
            _map.Transits[index] = transit;
            SaveData();
        }
    }

    public void DeleteTransit(Guid id)
    {
        _map.Transits.RemoveAll(t => t.Id == id);
        SaveData();
    }

    #endregion

    public AtlasMap GetFullSchema()
    {
        return _map;
    }

    public void ReplaceFullSchema(AtlasMap newMap)
    {
        _map.Zones = newMap.Zones;
        _map.Transits = newMap.Transits;
        SaveData();
    }
}
