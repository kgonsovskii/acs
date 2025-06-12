using System.IO.Compression;
using System.Text;
using System.Web;
using System.Text.RegularExpressions;

namespace SevenSeals.Tss.Atlas;

public class AtlasPlotter
{
    private readonly AtlasMap _map;

    public AtlasPlotter(AtlasMap map)
    {
        _map = map;
    }

    public string GeneratePlantUml()
    {
        var sb = new StringBuilder();
        sb.AppendLine("@startuml");
        sb.AppendLine("skinparam backgroundColor white");
        sb.AppendLine("skinparam defaultFontName Arial");
        sb.AppendLine("skinparam defaultFontSize 12");
        sb.AppendLine("skinparam roundcorner 10");
        sb.AppendLine("skinparam shadowing false");
        sb.AppendLine("skinparam ArrowColor #666666");
        sb.AppendLine("skinparam NodeBackgroundColor #FFFFFF");
        sb.AppendLine("skinparam NodeBorderColor #666666");

        // Add zones
        var topLevelZones = _map.Zones.Where(z => z.ParentId == null).ToList();
        foreach (var zone in topLevelZones)
        {
            AppendZoneHierarchy(sb, zone, 0);
        }

        // Add transits
        foreach (var transit in _map.Transits)
        {
            var fromZone = _map.Zones.FirstOrDefault(z => z.Id == transit.FromZoneId);
            var toZone = _map.Zones.FirstOrDefault(z => z.Id == transit.ToZoneId);

            if (fromZone != null && toZone != null)
            {
                var transitLabel = GetTransitLabel(transit);
                if (transit.IsBidirectional)
                {
                    sb.AppendLine($"{GetZoneId(fromZone)} <--> {GetZoneId(toZone)} : {transitLabel}");
                }
                else
                {
                    sb.AppendLine($"{GetZoneId(fromZone)} --> {GetZoneId(toZone)} : {transitLabel}");
                }
            }
        }

        sb.Append("@enduml");
        return sb.ToString();
    }

    public string GeneratePlantUmlUrl()
    {
        var plantUmlText = GeneratePlantUml();

        // Convert to UTF-8 bytes
        byte[] bytes = Encoding.UTF8.GetBytes(plantUmlText);

        // Compress using DEFLATE
        using var output = new MemoryStream();
        using (var deflate = new DeflateStream(output, CompressionLevel.Optimal, true)) // 'true' means leave the base stream open
        {
            deflate.Write(bytes, 0, bytes.Length);
        }

        // Convert to custom PlantUML Base64
        string base64 = Encode64(output.ToArray());

        return $"https://www.plantuml.com/plantuml/uml/{base64}";
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
        byte c1 = (byte)(b1 >> 2);
        byte c2 = (byte)(((b1 & 0x3) << 4) | (b2 >> 4));
        byte c3 = (byte)(((b2 & 0xF) << 2) | (b3 >> 6));
        byte c4 = (byte)(b3 & 0x3F);

        StringBuilder r = new StringBuilder();
        r.Append(Encode6Bit((byte)(c1 & 0x3F)));
        r.Append(Encode6Bit((byte)(c2 & 0x3F)));
        r.Append(Encode6Bit((byte)(c3 & 0x3F)));
        r.Append(Encode6Bit((byte)(c4 & 0x3F)));
        return r.ToString();
    }

    private static string Encode64(byte[] data)
    {
        StringBuilder str = new StringBuilder();
        int len = data.Length;
        for (int i = 0; i < len; i += 3)
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

    public void SavePlantUmlToFile(string filePath)
    {
        var plantUml = GeneratePlantUml();
        File.WriteAllText(filePath, plantUml);
    }

    private void AppendZoneHierarchy(StringBuilder sb, Zone zone, int indentLevel)
    {
        // Do not skip ExternalArea zones from the main hierarchy; render them as components.

        var indent = new string(' ', indentLevel * 2);
        var color = GetZoneColor(zone.Type);
        var zoneId = GetZoneId(zone);
        var zoneDisplayName = GetZoneDisplayName(zone);

        if (zone.Type == ZoneTypeEnum.Building || zone.Type == ZoneTypeEnum.Floor)
        {
            sb.AppendLine($@"{indent}package ""{zoneDisplayName}"" as {zoneId} {color} {{");
            var children = _map.Zones.Where(z => z.ParentId == zone.Id).ToList();
            foreach (var child in children)
            {
                AppendZoneHierarchy(sb, child, indentLevel + 1);
            }
            sb.AppendLine($@"{indent}}}");
        }
        else
        {
            // Render all other zone types, including ExternalArea, as components
            sb.AppendLine($@"{indent}component ""{zoneDisplayName}"" as {zoneId} {color}");
        }

        if (!string.IsNullOrEmpty(zone.Hint))
        {
            sb.AppendLine($@"{indent}note left of {zoneId} : {zone.Hint}");
        }
    }

    private static string GetTransitLabel(Transit transit)
    {
        // Assuming Transit has Name and Hint properties from AtlasBase
        if (!string.IsNullOrEmpty(transit.Name))
        {
            return transit.Name;
        }
        if (!string.IsNullOrEmpty(transit.Hint))
        {
            return transit.Hint;
        }
        return transit.GetType().Name; // Fallback to ClassName if no Name or Hint
    }

    private static string GetZoneDisplayName(Zone zone)
    {
        if (!string.IsNullOrEmpty(zone.Name))
        {
            return zone.Name;
        }
        if (!string.IsNullOrEmpty(zone.Hint))
        {
            return zone.Hint;
        }
        return $"{zone.GetType().Name} ({zone.Type})"; // Fallback to ClassName and ZoneType
    }

    private static string GetZoneId(Zone zone)
    {
        // Sanitize zone name to create a valid PlantUML ID, allowing Unicode letters and numbers
        var sanitizedName = Regex.Replace(zone.Name, @"[^\p{L}\p{N}_]", "_");
        var uniqueSuffix = zone.Id.ToString().Replace("-", "_").Substring(0, 8); // Use a portion of GUID for uniqueness

        // If sanitized name is empty or very generic, ensure uniqueness with the GUID suffix
        if (string.IsNullOrEmpty(sanitizedName) || sanitizedName == "_")
        {
            return $"zone_{uniqueSuffix}";
        }
        return $"zone_{sanitizedName}_{uniqueSuffix}";
    }

    private static string GetZoneColor(ZoneTypeEnum type)
    {
        return type switch
        {
            ZoneTypeEnum.Building => "#FFE4E1", // Misty Rose
            ZoneTypeEnum.Floor => "#E6E6FA",    // Lavender
            ZoneTypeEnum.Room => "#F0FFF0",     // Honeydew
            ZoneTypeEnum.Corridor => "#F5F5DC", // Beige
            ZoneTypeEnum.Lobby => "#FFDAB9",    // Peach Puff
            ZoneTypeEnum.Elevator => "#D8BFD8", // Thistle
            ZoneTypeEnum.Staircase => "#F0F8FF",// Alice Blue
            ZoneTypeEnum.Parking => "#E0FFFF",  // Light Cyan
            ZoneTypeEnum.ExternalArea => "#F5F5F5", // White Smoke
            _ => "#FFFFFF"                      // White
        };
    }
}
