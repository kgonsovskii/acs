using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class SpotResponse : ResponseBase
{
    /// <summary>
    /// The unique identifier for the current or reused session.
    /// </summary>
    public required string SessionId { get; init; }
}
