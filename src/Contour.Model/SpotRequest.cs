using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class SpotRequest : RequestBase
{
    /// <summary>
    /// The hostname or IP address of the spot device to connect to.
    /// Required if SessionId is not provided.
    /// </summary>
    public string Host { get; set; }

    /// <summary>
    /// The port number on which the spot device is listening.
    /// Required if SessionId is not provided.
    /// </summary>
    public int Port { get; set; }

    /// <summary>
    /// The logical address of spot device.
    /// </summary>
    public string Address { get; set; }

    /// <summary>
    /// The identifier of an existing session to reuse.
    /// If provided, Host and Port are ignored.
    /// </summary>
    public string? SessionId { get; set; }
}
