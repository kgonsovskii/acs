using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Api;

public class SpotResponse : ProtoResponse
{
    /// <summary>
    /// The unique identifier for the current or reused session.
    /// </summary>
    public string SessionId { get; init; } = string.Empty;
}
