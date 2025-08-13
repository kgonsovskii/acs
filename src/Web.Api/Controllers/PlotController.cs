using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Atlas;

namespace SevenSeals.Tss.Web.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PlotController : ControllerBase
    {
        private readonly IAtlasClient _atlasClient;

        public PlotController(IAtlasClient atlasClient)
        {
            _atlasClient = atlasClient;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var map = await _atlasClient.Schema();
            return new JsonResult(map);
        }

        [HttpGet("tree")]
        public async Task<IActionResult> GetTree()
        {
            var map = await _atlasClient.Schema();
            var zones = map.Zones;
            var transits = map.Transits;

            var external = zones.FirstOrDefault(z => z.Type == ZoneType.ExternalArea);
            if (external == null) return NotFound();

            var buildings = zones.Where(z => z.Type == ZoneType.Building && z.ParentId == external.Id).ToList();

            var buildingNodes = buildings.Select(b => {
                var floors = zones.Where(z => (z.Type == ZoneType.Floor) && z.ParentId == b.Id)
                    .OrderBy(z => z.Order)
                    .ToList();

                var floorNodes = floors.Select(f => new {
                    id = f.Id.ToString(),
                    name = f.Name,
                    type = f.Type.ToString().ToLower(),
                    children = zones.Where(z => z.ParentId == f.Id && z.Type != ZoneType.Floor)
                        .OrderBy(z => z.Order)
                        .Select(z => new {
                            id = z.Id.ToString(),
                            name = z.Name,
                            type = z.Type.ToString().ToLower()
                        }).ToList()
                }).ToList();

                return new {
                    id = b.Id.ToString(),
                    name = b.Name,
                    type = b.Type.ToString().ToLower(),
                    children = floorNodes
                };
            }).ToList();

            var tree = new List<object> {
                new {
                    id = external.Id.ToString(),
                    name = external.Name,
                    type = external.Type.ToString().ToLower(),
                    children = buildingNodes
                }
            };

            return new JsonResult(tree);
        }

        [HttpGet("addressbar/{planFile}")]
        public async Task<IActionResult> GetAddressBar(string planFile)
        {
            var map = await _atlasClient.Schema();
            var zones = map.Zones;

            var path = FindPathToPlanFile(zones, planFile);
            if (path == null)
                return NotFound();

            return new JsonResult(path);
        }

        private List<object> FindPathToPlanFile(List<Zone> zones, string planFile)
        {
            var targetZone = zones.FirstOrDefault(z => z.Design == planFile);
            if (targetZone == null)
                return null;

            var path = new List<object>();
            var currentZone = targetZone;

            while (currentZone != null)
            {
                path.Insert(0, new {
                    id = currentZone.Id.ToString(),
                    name = currentZone.Name,
                    planFile = currentZone.Design
                });

                currentZone = currentZone.ParentId.HasValue
                    ? zones.FirstOrDefault(z => z.Id == currentZone.ParentId.Value)
                    : null;
            }

            return path;
        }

        [HttpGet("plan/{zoneId}")]
        public async Task<IActionResult> GetPlan(string zoneId)
        {
            if (!Guid.TryParse(zoneId, out var zoneGuid))
                return BadRequest("Invalid zone ID format");

            var map = await _atlasClient.Schema();
            var zones = map.Zones;
            var transits = map.Transits;

            var selected = zones.FirstOrDefault(z => z.Id == zoneGuid);
            if (selected == null) return NotFound();

            if (!string.IsNullOrEmpty(selected.Design))
            {
                return await GeneratePlanForZone(selected, zones, transits);
            }

            return await GeneratePlanForZone(selected, zones, transits);
        }

        private Task<IActionResult> GeneratePlanForZone(Zone selectedZone, List<Zone> zones, List<Transit> transits)
        {
            double w = 3, h = 2, gap = 0.5;
            var shapes = new List<object>();

            var children = zones.Where(z => z.ParentId == selectedZone.Id).ToList();
            double curX = 0;
            var zoneCenters = new Dictionary<Guid, (double x, double y)>();

            foreach (var child in children)
            {
                shapes.Add(new {
                    type = "rect",
                    x = curX,
                    y = 0,
                    w = w,
                    h = h,
                    fill = "#e0e7ef",
                    stroke = "#555",
                    text = child.Name,
                    zoneId = child.Id.ToString()
                });

                zoneCenters[child.Id] = (curX + w / 2, h / 2);
                curX += w + gap;
            }

            var corridor = children.FirstOrDefault(z => z.Type == ZoneType.Corridor);
            if (corridor != null)
            {
                shapes.Add(new {
                    type = "rect",
                    x = 0,
                    y = h,
                    w = Math.Max(curX - gap, 6),
                    h = h,
                    fill = "#e6ebf1",
                    stroke = "#888",
                    text = corridor.Name,
                    zoneId = corridor.Id.ToString()
                });
                zoneCenters[corridor.Id] = (Math.Max(curX - gap, 6) / 2, h + h / 2);
            }

            foreach (var transit in transits)
            {
                var fromId = transit.FromZoneId;
                var toId = transit.ToZoneId;

                if (zoneCenters.ContainsKey(fromId) && zoneCenters.ContainsKey(toId))
                {
                    var from = zoneCenters[fromId];
                    var to = zoneCenters[toId];

                    if (children.Any(z => z.Id == fromId) && children.Any(z => z.Id == toId))
                    {
                        shapes.Add(new {
                            type = "transit",
                            x = (from.x + to.x) / 2,
                            y = (from.y + to.y) / 2,
                            r = 8,
                            fill = "blue",
                            stroke = "navy",
                            text = transit.Name,
                            fromZoneId = fromId.ToString(),
                            toZoneId = toId.ToString()
                        });
                    }
                }
            }

            return Task.FromResult<IActionResult>(new JsonResult(new {
                planWidth = Math.Max(curX, 6),
                planHeight = 4,
                shapes
            }));
        }
    }
}
