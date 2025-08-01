using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace SevenSeals.Tss.Web.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PlotController : ControllerBase
    {
        private readonly string _dataDir = Path.Combine("data");
        private readonly string _atlasPath;
        public PlotController()
        {
            _atlasPath = Path.Combine(_dataDir, "atlas.json");
        }

        [HttpGet("{name}")]
        public async Task<IActionResult> Get(string name)
        {
            var fileName = name + ".json";
            var filePath = Path.Combine(_dataDir, fileName);
            if (!System.IO.File.Exists(filePath))
                return NotFound();
            var json = await System.IO.File.ReadAllTextAsync(filePath);
            return Content(json, "application/json");
        }

        [HttpGet("tree")]
        public IActionResult GetTree()
        {
            if (!System.IO.File.Exists(_atlasPath))
                return NotFound();
            var json = System.IO.File.ReadAllText(_atlasPath);
            var doc = JsonNode.Parse(json);
            var zones = doc["zones"].AsArray();
            // Find the single external area (root)
            var external = zones.FirstOrDefault(z => z["type"].ToString() == "externalArea");
            if (external == null) return NotFound();
            // Find buildings under external area
            var buildings = zones.Where(z => z["type"].ToString() == "building" && z["parentId"] != null && z["parentId"].ToString() == external["id"].ToString()).ToList();
            // For each building, find floors
            var buildingNodes = buildings.Select(b => {
                var floors = zones.Where(z => (z["type"].ToString() == "floor" || z["type"].ToString().Contains("floor")) && z["parentId"] != null && z["parentId"].ToString() == b["id"].ToString())
                    .OrderBy(z => z["order"]?.GetValue<int>() ?? 0)
                    .ToList();
                // For each floor, find all other zones (rooms, corridors, etc.)
                var floorNodes = floors.Select(f => new {
                    id = f["id"].ToString(),
                    name = f["name"].ToString(),
                    type = f["type"].ToString(),
                    children = zones.Where(z => z["parentId"] != null && z["parentId"].ToString() == f["id"].ToString() && z["type"].ToString() != "floor" && !z["type"].ToString().Contains("floor"))
                        .OrderBy(z => z["order"]?.GetValue<int>() ?? 0)
                        .Select(z => new {
                            id = z["id"].ToString(),
                            name = z["name"].ToString(),
                            type = z["type"].ToString()
                        }).ToList()
                }).ToList();
                return new {
                    id = b["id"].ToString(),
                    name = b["name"].ToString(),
                    type = b["type"].ToString(),
                    children = floorNodes
                };
            }).ToList();
            var tree = new List<object> {
                new {
                    id = external["id"].ToString(),
                    name = external["name"].ToString(),
                    type = external["type"].ToString(),
                    children = buildingNodes
                }
            };
            return new JsonResult(tree);
        }

        [HttpGet("addressbar/{planFile}")]
        public async Task<IActionResult> GetAddressBar(string planFile)
        {
            var atlasPath = Path.Combine(_dataDir, "atlas.json");
            if (!System.IO.File.Exists(atlasPath))
                return NotFound();
            var json = await System.IO.File.ReadAllTextAsync(atlasPath);
            var atlas = System.Text.Json.JsonDocument.Parse(json).RootElement;
            var path = FindPathToPlanFile(atlas.GetProperty("nodes"), planFile);
            if (path == null)
                return NotFound();
            return new JsonResult(path);
        }

        private List<object> FindPathToPlanFile(System.Text.Json.JsonElement nodes, string planFile)
        {
            foreach (var node in nodes.EnumerateArray())
            {
                if (node.TryGetProperty("planFile", out var pf) && pf.GetString() == planFile)
                {
                    return new List<object> { new { id = node.GetProperty("id").GetString(), name = node.GetProperty("name").GetString(), planFile = pf.GetString() } };
                }
                if (node.TryGetProperty("children", out var children))
                {
                    var childPath = FindPathToPlanFile(children, planFile);
                    if (childPath != null)
                    {
                        var thisNode = new { id = node.GetProperty("id").GetString(), name = node.GetProperty("name").GetString(), planFile = node.TryGetProperty("planFile", out var npf) ? npf.GetString() : null };
                        var result = new List<object> { thisNode };
                        result.AddRange(childPath);
                        return result;
                    }
                }
            }
            return null;
        }

        [HttpGet("plan/{zoneId}")]
        public IActionResult GetPlan(string zoneId)
        {
            if (!System.IO.File.Exists(_atlasPath))
                return NotFound();
            var json = System.IO.File.ReadAllText(_atlasPath);
            var doc = JsonNode.Parse(json);
            var zones = doc["zones"].AsArray();
            var transits = doc["transits"].AsArray();
            // Find selected zone
            var selected = zones.FirstOrDefault(z => z["id"].ToString() == zoneId);
            if (selected == null) return NotFound();
            var designNode = selected["design"];
            if (designNode is JsonValue v && v.TryGetValue<string>(out var designFile))
            {
                var designPath = Path.Combine(_dataDir, designFile);
                if (!System.IO.File.Exists(designPath))
                    return NotFound();
                var designJson = System.IO.File.ReadAllText(designPath);
                var designDoc = JsonNode.Parse(designJson);
                // Add relevant transits to designDoc.shapes
                var shapesNode = designDoc["shapes"] as JsonArray;
                if (shapesNode == null)
                {
                    shapesNode = new JsonArray();
                    designDoc["shapes"] = shapesNode;
                }
                // Find all zone IDs in the design shapes
                var zoneIds = new HashSet<string>();
                foreach (var shape in shapesNode)
                {
                    if (shape?["zoneId"] != null)
                        zoneIds.Add(shape["zoneId"].ToString());
                }
                foreach (var transit in transits)
                {
                    var fromId = transit["fromZoneId"].ToString();
                    var toId = transit["toZoneId"].ToString();
                    if (zoneIds.Contains(fromId) && zoneIds.Contains(toId))
                    {
                        // Find centers of from and to zones
                        var fromShape = shapesNode.FirstOrDefault(s => s?["zoneId"]?.ToString() == fromId);
                        var toShape = shapesNode.FirstOrDefault(s => s?["zoneId"]?.ToString() == toId);
                        if (fromShape != null && toShape != null)
                        {
                            double fx = fromShape["x"]?.GetValue<double>() ?? 0;
                            double fy = fromShape["y"]?.GetValue<double>() ?? 0;
                            double fw = fromShape["w"]?.GetValue<double>() ?? 1;
                            double fh = fromShape["h"]?.GetValue<double>() ?? 1;
                            double tx = toShape["x"]?.GetValue<double>() ?? 0;
                            double ty = toShape["y"]?.GetValue<double>() ?? 0;
                            double tw = toShape["w"]?.GetValue<double>() ?? 1;
                            double th = toShape["h"]?.GetValue<double>() ?? 1;
                            double cx = (fx + fw / 2 + tx + tw / 2) / 2;
                            double cy = (fy + fh / 2 + ty + th / 2) / 2;
                            var transitShape = new JsonObject {
                                ["type"] = "transit",
                                ["x"] = cx,
                                ["y"] = cy,
                                ["r"] = 8,
                                ["fill"] = "blue",
                                ["stroke"] = "navy",
                                ["text"] = transit["name"].ToString(),
                                ["fromZoneId"] = fromId,
                                ["toZoneId"] = toId
                            };
                            shapesNode.Add(transitShape);
                        }
                    }
                }
                return new JsonResult(designDoc);
            }
            // Fallback: auto-generate plan as before
            double x = 0, y = 0, w = 3, h = 2, gap = 0.5;
            var shapes = new List<object>();
            var children = zones.Where(z => z["parentId"] != null && z["parentId"].ToString() == zoneId).ToList();
            double curX = 0;
            var zoneCenters = new Dictionary<string, (double x, double y)>();
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
                    text = child["name"].ToString(),
                    zoneId = child["id"].ToString()
                });
                // Store center for transit plotting
                zoneCenters[child["id"].ToString()] = (curX + w / 2, h / 2);
                curX += w + gap;
            }
            // Add corridor/other zones below (if any)
            var corridor = children.FirstOrDefault(z => z["type"].ToString() == "corridor");
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
                    text = corridor["name"].ToString(),
                    zoneId = corridor["id"].ToString()
                });
                zoneCenters[corridor["id"].ToString()] = (Math.Max(curX - gap, 6) / 2, h + h / 2);
            }
            // Add transits as shapes
            foreach (var transit in transits)
            {
                var fromId = transit["fromZoneId"].ToString();
                var toId = transit["toZoneId"].ToString();
                System.Diagnostics.Debug.WriteLine($"Processing transit: fromId={fromId}, toId={toId}, zoneId={zoneId}");
                System.Diagnostics.Debug.WriteLine($"zoneCenters keys: {string.Join(",", zoneCenters.Keys)}");
                if (zoneCenters.ContainsKey(fromId) && zoneCenters.ContainsKey(toId))
                {
                    var from = zoneCenters[fromId];
                    var to = zoneCenters[toId];
                    if (fromId == zoneId || toId == zoneId)
                    {
                        System.Diagnostics.Debug.WriteLine($"Adding transit shape for zoneId={zoneId}");
                        shapes.Add(new {
                            type = "transit",
                            x = (from.x + to.x) / 2,
                            y = (from.y + to.y) / 2,
                            r = 8,
                            fill = "blue",
                            stroke = "navy",
                            text = transit["name"].ToString(),
                            fromZoneId = fromId,
                            toZoneId = toId
                        });
                    }
                }
            }
            return new JsonResult(new {
                planWidth = Math.Max(curX, 6),
                planHeight = 4,
                shapes
            });
        }
    }
}
