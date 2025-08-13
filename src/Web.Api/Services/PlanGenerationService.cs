using SevenSeals.Tss.Atlas;
using SevenSeals.Tss.Web.Api.Models;

namespace SevenSeals.Tss.Web.Api.Services
{
    public class PlanGenerationService : IPlanGenerationService
    {
        private const double RoomWidth = 2.5;
        private const double RoomHeight = 2.0;
        private const double Gap = 0.3;
        private const double CorridorHeight = 1.5;

        public PlanResponse GeneratePlanForZone(Zone selectedZone, Map map)
        {
            var allZonesInHierarchy = GetAllZonesInHierarchy(selectedZone, map);
            
            if (allZonesInHierarchy.Count == 0)
            {
                return new PlanResponse
                {
                    PlanWidth = 10,
                    PlanHeight = 6
                };
            }

            var response = new PlanResponse();
            var zoneCenters = new Dictionary<Guid, (double x, double y)>();

            var rooms = allZonesInHierarchy.Where(z => z.Type == ZoneType.Room).OrderBy(z => z.Order).ToList();
            var corridors = allZonesInHierarchy.Where(z => z.Type == ZoneType.Corridor).OrderBy(z => z.Order).ToList();

            Console.WriteLine($"Found {rooms.Count} rooms and {corridors.Count} corridors");
            Console.WriteLine($"Rooms: {string.Join(", ", rooms.Select(r => r.Name))}");
            Console.WriteLine($"Corridors: {string.Join(", ", corridors.Select(c => c.Name))}");

            AddRooms(response, rooms, zoneCenters);
            AddCorridors(response, corridors, zoneCenters);
            AddTransits(response, map.Transits, zoneCenters, allZonesInHierarchy);

            Console.WriteLine($"Total shapes generated: {response.Shapes.Count}");
            Console.WriteLine($"Shape types: {string.Join(", ", response.Shapes.Select(s => s.Type))}");
            
            foreach (var shape in response.Shapes)
            {
                if (shape is RectangleShape rect)
                {
                    Console.WriteLine($"Rectangle: x={rect.X}, y={rect.Y}, w={rect.W}, h={rect.H}, fill={rect.Fill}, text={rect.Text}");
                }
                else if (shape is TransitShape transit)
                {
                    Console.WriteLine($"Transit: x={transit.X}, y={transit.Y}, text={transit.Text}");
                }
            }

            response.PlanWidth = Math.Max(rooms.Count * (RoomWidth + Gap) - Gap, 8);
            response.PlanHeight = RoomHeight + Gap + CorridorHeight;

            return response;
        }

        private List<Zone> GetAllZonesInHierarchy(Zone selectedZone, Map map)
        {
            var result = new List<Zone>();
            var queue = new Queue<Zone>();
            queue.Enqueue(selectedZone);

            while (queue.Count > 0)
            {
                var current = queue.Dequeue();
                result.Add(current);

                var children = map.Zones.Where(z => z.ParentId == current.Id).OrderBy(z => z.Order).ToList();
                foreach (var child in children)
                {
                    queue.Enqueue(child);
                }
            }

            return result;
        }

        private void AddRooms(PlanResponse response, List<Zone> rooms, Dictionary<Guid, (double x, double y)> zoneCenters)
        {
            double curX = 0;
            Console.WriteLine($"Adding {rooms.Count} rooms");

            foreach (var room in rooms)
            {
                var shape = new RectangleShape
                {
                    X = curX,
                    Y = 0,
                    W = RoomWidth,
                    H = RoomHeight,
                    Fill = "#e0e7ef",
                    Stroke = "#555",
                    StrokeWidth = 2,
                    Text = room.Name ?? "Unknown",
                    ZoneId = room.Id.ToString()
                };

                response.Shapes.Add(shape);
                zoneCenters[room.Id] = (curX + RoomWidth / 2, RoomHeight / 2);
                curX += RoomWidth + Gap;
                Console.WriteLine($"Added room: {room.Name} at ({curX}, 0)");
            }
        }

        private void AddCorridors(PlanResponse response, List<Zone> corridors, Dictionary<Guid, (double x, double y)> zoneCenters)
        {
            if (corridors.Count == 0) return;

            Console.WriteLine($"Adding {corridors.Count} corridors");
            var rooms = response.Shapes.OfType<RectangleShape>().Where(s => s.Y == 0).ToList();
            double corridorWidth = rooms.Count > 0 ? Math.Max(rooms.Count * (RoomWidth + Gap) - Gap, 6) : 6;

            foreach (var corridor in corridors)
            {
                var shape = new RectangleShape
                {
                    X = 0,
                    Y = RoomHeight + Gap,
                    W = corridorWidth,
                    H = CorridorHeight,
                    Fill = "#e6ebf1",
                    Stroke = "#888",
                    StrokeWidth = 2,
                    Text = corridor.Name ?? "Unknown",
                    ZoneId = corridor.Id.ToString()
                };

                response.Shapes.Add(shape);
                zoneCenters[corridor.Id] = (corridorWidth / 2, RoomHeight + Gap + CorridorHeight / 2);
                Console.WriteLine($"Added corridor: {corridor.Name}");
            }
        }

        private void AddTransits(PlanResponse response, List<Transit> transits, Dictionary<Guid, (double x, double y)> zoneCenters, List<Zone> children)
        {
            foreach (var transit in transits)
            {
                if (!zoneCenters.ContainsKey(transit.FromZoneId) || !zoneCenters.ContainsKey(transit.ToZoneId))
                    continue;

                var from = zoneCenters[transit.FromZoneId];
                var to = zoneCenters[transit.ToZoneId];

                if (!children.Any(z => z.Id == transit.FromZoneId) || !children.Any(z => z.Id == transit.ToZoneId))
                    continue;

                var shape = new TransitShape
                {
                    X = (from.x + to.x) / 2,
                    Y = (from.y + to.y) / 2,
                    R = 6,
                    Fill = "blue",
                    Stroke = "navy",
                    StrokeWidth = 2,
                    Text = transit.Name ?? "Unknown",
                    FromZoneId = transit.FromZoneId.ToString(),
                    ToZoneId = transit.ToZoneId.ToString()
                };

                response.Shapes.Add(shape);
            }
        }
    }
}
