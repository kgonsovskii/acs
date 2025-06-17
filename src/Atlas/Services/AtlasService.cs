using SevenSeals.Tss.Atlas.Storage;

namespace SevenSeals.Tss.Atlas.Services;

public interface IAtlasService
{
    public Map Schema();

    public void Schema(Map map);
}

public class AtlasService: IAtlasService
{
    private readonly ITransitStorage _transitStorage;
    private readonly IZoneStorage _zoneStorage;

    public AtlasService(IZoneStorage zoneStorage, ITransitStorage transitStorage)
    {
        _transitStorage = transitStorage;
        _zoneStorage = zoneStorage;
    }

    public Map Schema()
    {
        return new Map()
        {
            Zones = _zoneStorage.GetAll().ToList(),
            Transits = _transitStorage.GetAll().ToList()
        };
    }

    public void Schema(Map map)
    {
        _zoneStorage.SetAll(map.Zones);
        _transitStorage.SetAll(map.Transits);
    }
}

