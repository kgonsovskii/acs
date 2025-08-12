using System;
using System.Collections.Generic;
using System.IO.Compression;
using System.Linq;
using System.Text;
using SevenSeals.Tss.Atlas;

namespace Atlas.Component
{
    public enum PlotOrientation
    {
        Horizontal,
        Vertical
    }

    public class AtlasPlotter
    {
        private readonly Map _map;
        private readonly PlotOrientation _orientation;

        public AtlasPlotter(Map map, PlotOrientation orientation = PlotOrientation.Horizontal)
        {
            _map = map ?? throw new ArgumentNullException(nameof(map));
            _orientation = orientation;
        }

        public string GeneratePlantUml()
        {
            var sb = new StringBuilder();
            sb.AppendLine("@startuml");
            sb.AppendLine("skinparam backgroundColor white");
            sb.AppendLine("skinparam defaultFontName Arial");
            sb.AppendLine("skinparam defaultFontSize 16");
            sb.AppendLine("skinparam defaultFontStyle bold");
            sb.AppendLine("skinparam roundcorner 10");
            sb.AppendLine("skinparam shadowing false");
            sb.AppendLine("skinparam NodeBackgroundColor #FFFFFF");
            sb.AppendLine("skinparam NodeBorderColor #666666");

            // Add orientation-specific layout hints
            if (_orientation == PlotOrientation.Vertical)
            {
                sb.AppendLine("skinparam rankdir TB"); // Top to Bottom
            }
            else
            {
                sb.AppendLine("skinparam rankdir LR"); // Left to Right
            }

            // First, declare all zones as components
            foreach (var zone in _map.Zones.OrderBy(z => z.Order))
            {
                var zoneId = GetZoneId(zone);
                var zoneDisplayName = GetZoneDisplayName(zone);
                sb.AppendLine($"component \"{zoneDisplayName}\" as {zoneId}");
                
                if (!string.IsNullOrEmpty(zone.Hint))
                {
                    sb.AppendLine($"note left of {zoneId} : {zone.Hint}");
                }
            }

            // Add explicit transits with bold styling
            foreach (var transit in _map.Transits.OrderBy(t => t.Order))
            {
                var fromZone = _map.Zones.FirstOrDefault(z => z.Id == transit.FromZoneId);
                var toZone = _map.Zones.FirstOrDefault(z => z.Id == transit.ToZoneId);

                if (fromZone != null && toZone != null)
                {
                    var transitLabel = GetTransitLabel(transit);
                    if (transit.IsBidirectional)
                    {
                        sb.AppendLine($"{GetZoneId(fromZone)} <--> {GetZoneId(toZone)} : {transitLabel} #2E86AB");
                    }
                    else
                    {
                        sb.AppendLine($"{GetZoneId(fromZone)} --> {GetZoneId(toZone)} : {transitLabel} #2E86AB");
                    }
                }
            }

            // Add parent-child relationships as implicit connections
            foreach (var zone in _map.Zones.Where(z => z.ParentId.HasValue))
            {
                var parentZone = _map.Zones.FirstOrDefault(z => z.Id == zone.ParentId.Value);
                if (parentZone != null)
                {
                    // Check if there's already an explicit transit between these zones
                    var existingTransit = _map.Transits.FirstOrDefault(t => 
                        (t.FromZoneId == parentZone.Id && t.ToZoneId == zone.Id) ||
                        (t.FromZoneId == zone.Id && t.ToZoneId == parentZone.Id));
                    
                    // Only add parent-child connection if there's NO explicit transit
                    if (existingTransit == null)
                    {
                        // Add implicit parent-child connection (no label)
                        sb.AppendLine($"{GetZoneId(parentZone)} --> {GetZoneId(zone)}");
                    }
                    // If there IS an explicit transit, we skip the parent-child relationship
                    // because the transit will be handled in the transits loop above
                }
            }

            sb.AppendLine("@enduml");
            return sb.ToString();
        }

        private string GeneratePlantUmlUrlBase64()
        {
            var plantUmlText = GeneratePlantUml();

            // Convert to UTF-8 bytes
            var bytes = Encoding.UTF8.GetBytes(plantUmlText);

            // Compress using DEFLATE
            using var output = new MemoryStream();
            using (var deflate = new DeflateStream(output, CompressionLevel.Optimal, true))
            {
                deflate.Write(bytes, 0, bytes.Length);
            }

            // Convert to custom PlantUML Base64
            var base64 = Encode64(output.ToArray());

            return base64;
        }

        public string GeneratePlantUmlUrl()
        {
            return $"https://www.plantuml.com/plantuml/uml/{GeneratePlantUmlUrlBase64()}";
        }

        public string GeneratePlantUmlImageUrl()
        {
            return $"https://www.plantuml.com/plantuml/png/{GeneratePlantUmlUrlBase64()}";
        }

        private static string Encode6Bit(byte b)
        {
            if (b < 10)
            {
                return ((char)(48 + b)).ToString();
            }
            b -= 10;
            if (b < 26)
            {
                return ((char)(65 + b)).ToString();
            }
            b -= 26;
            if (b < 26)
            {
                return ((char)(97 + b)).ToString();
            }
            b -= 26;
            if (b == 0)
            {
                return "-";
            }
            if (b == 1)
            {
                return "_";
            }
            return "?";
        }

        private static string Append3Bytes(byte b1, byte b2, byte b3)
        {
            var c1 = (byte)(b1 >> 2);
            var c2 = (byte)(((b1 & 0x3) << 4) | (b2 >> 4));
            var c3 = (byte)(((b2 & 0xF) << 2) | (b3 >> 6));
            var c4 = (byte)(b3 & 0x3F);

            var r = new StringBuilder();
            r.Append(Encode6Bit((byte)(c1 & 0x3F)));
            r.Append(Encode6Bit((byte)(c2 & 0x3F)));
            r.Append(Encode6Bit((byte)(c3 & 0x3F)));
            r.Append(Encode6Bit((byte)(c4 & 0x3F)));
            return r.ToString();
        }

        private static string Encode64(byte[] data)
        {
            var str = new StringBuilder();
            var len = data.Length;
            for (var i = 0; i < len; i += 3)
            {
                if (i + 2 == len)
                {
                    str.Append(Append3Bytes(data[i], data[i + 1], 0));
                }
                else if (i + 1 == len)
                {
                    str.Append(Append3Bytes(data[i], 0, 0));
                }
                else
                {
                    str.Append(Append3Bytes(data[i], data[i + 1], data[i + 2]));
                }
            }
            return str.ToString();
        }

        private string GetZoneId(Zone zone)
        {
            return $"zone_{zone.Name?.Replace(" ", "_").Replace("-", "_")}";
        }

        private string GetZoneDisplayName(Zone zone)
        {
            return zone.Name ?? string.Empty;
        }

        private string GetZoneColor(ZoneType zoneType)
        {
            return zoneType switch
            {
                ZoneType.ExternalArea => "#F5F5F5",
                ZoneType.Building => "#FFE4E1",
                ZoneType.Floor => "#E6E6FA",
                ZoneType.Room => "#F0FFF0",
                ZoneType.Corridor => "#F5F5DC",
                _ => "#FFFFFF"
            };
        }

        private string GetTransitLabel(Transit transit)
        {
            var name = string.IsNullOrEmpty(transit.Name) ? "transit" : transit.Name;
            var hint = transit.Hint;
            
            if (!string.IsNullOrEmpty(hint))
            {
                // Show both name and hint separated by a dash
                return $"{name} - {hint}";
            }
            
            return name;
        }
    }
}
