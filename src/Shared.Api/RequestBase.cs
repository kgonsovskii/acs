namespace SevenSeals.Tss.Shared;

public abstract class RequestBase: Proto
{
    /// <summary>
    /// Trace identifier for request
    /// </summary>
    public override string TraceId { get; set; } = string.Empty;
}
