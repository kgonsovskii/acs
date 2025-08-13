using Atlas.Component;
using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Atlas;
using SevenSeals.Tss.Web.Api.Models;
using SevenSeals.Tss.Web.Api.Services;

namespace SevenSeals.Tss.Web.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PlotController : ControllerBase
    {
        private readonly IAtlasService _atlasService;
        private readonly IPlanGenerationService _planGenerationService;

        public PlotController(IAtlasService atlasService, IPlanGenerationService planGenerationService)
        {
            _atlasService = atlasService;
            _planGenerationService = planGenerationService;
        }

        [HttpGet("api")]
        public async Task<IActionResult> ApiInfo()
        {
            try
            {
                var map = _atlasService.Schema();
                return new JsonResult(new
                {
                    message = "SevenSeals TSS Atlas Plot API",
                    timestamp = DateTime.UtcNow,
                    data = map,
                    endpoints = new
                    {
                        api = "/api/Plot/api",
                        tree = "/api/Plot/tree",
                        plan = "/api/Plot/plan/{zoneId}"
                    }
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = "Failed to load atlas data", message = ex.Message });
            }
        }

        [HttpGet("tree")]
        public async Task<IActionResult> GetTree()
        {
            var map = _atlasService.Schema();
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

        [HttpGet("plan/{zoneId}")]
        public async Task<IActionResult> GetPlan(string zoneId)
        {
            if (!Guid.TryParse(zoneId, out var zoneGuid))
                return BadRequest("Invalid zone ID format");

            var map = _atlasService.Schema();
            var zones = map.Zones;
            var transits = map.Transits;

            var selected = zones.FirstOrDefault(z => z.Id == zoneGuid);
            if (selected == null) return NotFound();

            var plan = _planGenerationService.GeneratePlanForZone(selected, map);
            return new JsonResult(plan);
        }
    }
}
