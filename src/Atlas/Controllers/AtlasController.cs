using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AtlasController : ProtoController<AtlasRequestBase, AtlasResponseBase>
{
    private readonly AtlasStorage _storage;
    private readonly ILogger<AtlasController> _logger;

    public AtlasController(AtlasStorage storage, Settings settings, ILogger<AtlasController> logger) : base(settings)
    {
        _storage = storage;
        _logger = logger;
    }

    #region Zones

    [HttpGet("zones")]
    public ActionResult<IEnumerable<ZoneResponse>> GetAllZones()
    {
        var zones = _storage.GetAllZones();
        return Ok(zones.MapZonesToResponse());
    }

    [HttpGet("zones/{id}")]
    public ActionResult<ZoneResponse> GetZone(Guid id)
    {
        var zone = _storage.GetZone(id);
        if (zone == null)
        {
            return NotFound();
        }

        return Ok(zone.MapZoneToResponse());
    }

    [HttpPost("zones")]
    public ActionResult<ZoneResponse> CreateZone(ZoneRequest request)
    {
        var zone = new Zone
        {
            Id = Guid.NewGuid(),
            Name = request.Name,
            Type = request.Type
        };

        _storage.CreateZone(zone);
        return CreatedAtAction(nameof(GetZone), new { id = zone.Id }, zone.MapZoneToResponse());
    }

    [HttpPut("zones/{id}")]
    public ActionResult<ZoneResponse> UpdateZone(Guid id, ZoneUpdateRequest request)
    {
        var zone = _storage.GetZone(id);
        if (zone == null)
        {
            return NotFound();
        }

        zone.Name = request.Name;
        zone.Type = request.Type;

        _storage.UpdateZone(zone);
        return Ok(zone.MapZoneToResponse());
    }

    [HttpDelete("zones/{id}")]
    public ActionResult DeleteZone(Guid id)
    {
        var zone = _storage.GetZone(id);
        if (zone == null)
        {
            return NotFound();
        }

        _storage.DeleteZone(id);
        return NoContent();
    }

    #endregion

    #region Transits

    [HttpGet("transits")]
    public ActionResult<IEnumerable<TransitResponse>> GetAllTransits()
    {
        var transits = _storage.GetAllTransits();
        var zones = _storage.GetAllZones();
        return Ok(transits.MapTransitsToResponse(zones));
    }

    [HttpGet("transits/{id}")]
    public ActionResult<TransitResponse> GetTransit(Guid id)
    {
        var transit = _storage.GetTransit(id);
        if (transit == null)
        {
            return NotFound();
        }

        var zones = _storage.GetAllZones();
        return Ok(transit.MapTransitToResponse(zones));
    }

    [HttpPost("transits")]
    public ActionResult<TransitResponse> CreateTransit(TransitRequest request)
    {
        var fromZone = _storage.GetZone(request.FromZoneId);
        var toZone = _storage.GetZone(request.ToZoneId);

        if (fromZone == null || toZone == null)
        {
            return BadRequest("One or both zones do not exist");
        }

        var transit = new Transit
        {
            Id = Guid.NewGuid(),
            FromZoneId = request.FromZoneId,
            ToZoneId = request.ToZoneId,
            IsBidirectional = request.IsBidirectional
        };

        _storage.CreateTransit(transit);
        var zones = _storage.GetAllZones();
        return CreatedAtAction(nameof(GetTransit), new { id = transit.Id }, transit.MapTransitToResponse(zones));
    }

    [HttpPut("transits/{id}")]
    public ActionResult<TransitResponse> UpdateTransit(Guid id, TransitUpdateRequest request)
    {
        var transit = _storage.GetTransit(id);
        if (transit == null)
        {
            return NotFound();
        }

        var fromZone = _storage.GetZone(request.FromZoneId);
        var toZone = _storage.GetZone(request.ToZoneId);

        if (fromZone == null || toZone == null)
        {
            return BadRequest("One or both zones do not exist");
        }

        transit.FromZoneId = request.FromZoneId;
        transit.ToZoneId = request.ToZoneId;
        transit.IsBidirectional = request.IsBidirectional;

        _storage.UpdateTransit(transit);
        var zones = _storage.GetAllZones();
        return Ok(transit.MapTransitToResponse(zones));
    }

    [HttpDelete("transits/{id}")]
    public ActionResult DeleteTransit(Guid id)
    {
        var transit = _storage.GetTransit(id);
        if (transit == null)
        {
            return NotFound();
        }

        _storage.DeleteTransit(id);
        return NoContent();
    }

    #endregion

    #region Schema

    [HttpGet("schema")]
    public ActionResult<AtlasMap> GetFullSchema()
    {
        return Ok(_storage.GetFullSchema());
    }

    [HttpPut("schema")]
    public ActionResult ReplaceFullSchema(AtlasMap schema)
    {
        if (schema == null)
        {
            return BadRequest("Schema cannot be null");
        }

        _storage.ReplaceFullSchema(schema);
        return NoContent();
    }

    #endregion
}
