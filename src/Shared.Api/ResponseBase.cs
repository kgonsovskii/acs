namespace SevenSeals.Tss.Shared;

public abstract class ResponseBase
{
    /// <summary>
    /// Trace identifier for correlating requests and responses.
    /// </summary>
    public string TraceId { get; set; } = string.Empty;
}
