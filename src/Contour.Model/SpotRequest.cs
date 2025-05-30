public class SpotRequest : ChannelRequest
{
    /// <summary>
    /// The logical address of spot device.
    /// </summary>
    public string Address { get; set; } = string.Empty;

    public byte AddressByte => byte.Parse(Address);
}