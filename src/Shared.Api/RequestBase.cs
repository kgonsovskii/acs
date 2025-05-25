namespace SevenSeals.Tss.Shared;

public abstract class RequestBase
{
    public string TraceId { get; } = Guid.NewGuid().ToString();
}
