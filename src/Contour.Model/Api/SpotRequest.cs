using System.Text.Json.Serialization;

namespace SevenSeals.Tss.Contour.Api;

public class SpotRequest : ChannelRequest
{
    /// <summary>
    /// The logical address of spot device.
    /// </summary>
    public string Address { get; set; } = string.Empty;

    [JsonIgnore]
    public byte AddressByte => byte.Parse(Address);
}
