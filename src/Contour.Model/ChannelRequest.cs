using System.Runtime.Serialization;
using System.Text.Json.Serialization;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

[KnownType(typeof(ChannelOptions))]
public abstract class ChannelRequest: RequestBase
{
    [JsonConverter(typeof(ChannelOptionsJsonConverter))]
    public ChannelOptions Options { get; set; }

    public IpOptions AsIpOptions() => (Options as IpOptions)!;

    public ComPortOptions AsComPortOptions() => (Options as ComPortOptions)!;

    /// <summary>
    /// The identifier of an existing session to reuse.
    /// If provided, Host and Port are ignored.
    /// </summary>
    public string? SessionId { get; set; }
}