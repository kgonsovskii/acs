namespace SevenSeals.Tss.Shared;

public abstract class ResponseBase: Proto
{
    /// <summary>
    /// Trace identifier for correlating requests and responses.
    /// </summary>
    public override string TraceId { get; set; } = string.Empty;

    public virtual long TimeStamp { get; set; } = 0;
}
