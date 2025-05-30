using SevenSeals.Tss.Shared;

public abstract class ChannelRequest: RequestBase
{
    /// <summary>
    /// The hostname or IP address of the spot device to connect to.
    /// Required if SessionId is not provided.
    /// </summary>
    public string Host { get; set; } = string.Empty;

    /// <summary>
    /// The port number on which the spot device is listening.
    /// Required if SessionId is not provided.
    /// </summary>
    public int Port { get; set; }

    /// <summary>
    /// The identifier of an existing session to reuse.
    /// If provided, Host and Port are ignored.
    /// </summary>
    public string? SessionId { get; set; }
}