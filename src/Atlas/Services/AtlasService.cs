using SevenSeals.Tss.Atlas.Api;
using Atlas.Component;

namespace SevenSeals.Tss.Atlas.Services;

public interface IAtlasService
{
    public Map Schema();

    public PlotResponse Plot(PlotOrientation orientation = PlotOrientation.Horizontal);

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
        var result = new Map()
        {
            Zones = _zoneStorage.GetAll().ToList(),
            Transits = _transitStorage.GetAll().ToList()
        };
        return result;
    }

    public void Schema(Map map)
    {
        _zoneStorage.SetAll(map.Zones);
        _transitStorage.SetAll(map.Transits);
    }

    public PlotResponse Plot(PlotOrientation orientation = PlotOrientation.Horizontal)
    {
        var map = Schema();
        var plotter = new AtlasPlotter(map, orientation);
        return new PlotResponse()
        {
            Url = plotter.GeneratePlantUmlUrl(),
            UrlImage = plotter.GeneratePlantUmlImageUrl()
        };
    }
}

