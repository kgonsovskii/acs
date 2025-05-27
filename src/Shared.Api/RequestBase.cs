namespace SevenSeals.Tss.Shared;

public abstract class RequestBase
{
    /// <summary>
    /// Trace identifier for correlating requests.
    /// </summary>
    public string TraceId { get; } = Guid.NewGuid().ToString();
}
