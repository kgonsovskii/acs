using SevenSeals.Tss.Shared;

public class SpotResponse : ResponseBase
{
    /// <summary>
    /// The unique identifier for the current or reused session.
    /// </summary>
    public string SessionId { get; init; } = string.Empty;
}