using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;
public class ZoneResponse : ResponseBase
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public ZoneTypeEnum Type { get; set; }
    public Guid? ParentId { get; set; }
    public List<ZoneResponse> Children { get; set; } = new();
}
