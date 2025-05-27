namespace SevenSeals.Tss.Shared.Model;

public class StatusResponse : ResponseBase
{
    /// <summary>
    /// Name of the service.
    /// </summary>
    public string Service { get; set; } = string.Empty;

    /// <summary>
    /// Current status of the service (e.g., "Alive").
    /// </summary>
    public string Status { get; set; } = string.Empty;

    /// <summary>
    /// The UTC timestamp at which the status was generated.
    /// </summary>
    public string TimeStamp { get; set; } = string.Empty;
}
