using SevenSeals.Tss.Atlas.Storage;

namespace SevenSeals.Tss.Atlas.Services;

public interface IAtlasService
{
    public AtlasMap Schema();

    public void Schema(AtlasMap atlasMap);
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

    public AtlasMap Schema()
    {
        return new AtlasMap()
        {
            Zones = _zoneStorage.GetAll().ToList(),
            Transits = _transitStorage.GetAll().ToList()
        };
    }

    public void Schema(AtlasMap atlasMap)
    {
        _zoneStorage.SetAll(atlasMap.Zones);
        _transitStorage.SetAll(atlasMap.Transits);
    }
}

