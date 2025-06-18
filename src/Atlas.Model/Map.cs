using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public class Map: IProtoRequest, IProtoResponse
{
    public List<Zone> Zones { get; set; } = [];
    public List<Transit> Transits { get; set; } = [];
}
