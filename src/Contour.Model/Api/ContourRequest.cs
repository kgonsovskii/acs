using System.Text.Json.Serialization;

namespace SevenSeals.Tss.Contour.Api;

public class ContourRequest : ChannelRequest
{
    /// <summary>
    /// The logical address of spot device.
    /// </summary>
    public string Address { get; set; } = string.Empty;

    [JsonIgnore]
    public byte AddressByte => byte.Parse(Address);

    /// <summary>
    /// The ID of Spot Device. If set other params are ignored
    /// </summary>
    public Guid? SpotId { get; set; }
}
