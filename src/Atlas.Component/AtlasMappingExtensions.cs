namespace SevenSeals.Tss.Atlas;

public static class AtlasMappingExtensions
{
    public static IEnumerable<ZoneResponse> MapZonesToResponse(this IEnumerable<Zone> zones)
    {
        return zones.Select(MapZoneToResponse);
    }

    public static ZoneResponse MapZoneToResponse(this Zone zone)
    {
        return new ZoneResponse
        {
            Id = zone.Id,
            Name = zone.Name,
            Type = zone.Type
        };
    }

    public static IEnumerable<TransitResponse> MapTransitsToResponse(this IEnumerable<Transit> transits, IEnumerable<Zone> zones)
    {
        return transits.Select(t => t.MapTransitToResponse(zones));
    }

    public static TransitResponse MapTransitToResponse(this Transit transit, IEnumerable<Zone> zones)
    {
        var fromZone = zones.FirstOrDefault(z => z.Id == transit.FromZoneId);
        var toZone = zones.FirstOrDefault(z => z.Id == transit.ToZoneId);

        return new TransitResponse
        {
            Id = transit.Id,
            FromZoneId = transit.FromZoneId,
            ToZoneId = transit.ToZoneId,
            IsBidirectional = transit.IsBidirectional,
            FromZoneName = fromZone?.Name,
            ToZoneName = toZone?.Name
        };
    }
}
