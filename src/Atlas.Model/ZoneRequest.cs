using System.Text.Json.Serialization;

namespace SevenSeals.Tss.Atlas;

public class ZoneRequest: AtlasRequestBase
{
    public string Name { get; set; } = string.Empty;
    [JsonConverter(typeof(JsonStringEnumConverter))] public ZoneTypeEnum Type { get; set; }
    public Guid? ParentId { get; set; }
}

public class ZoneUpdateRequest : ZoneRequest
{
    public Guid Id { get; set; }
}
