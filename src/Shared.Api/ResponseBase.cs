namespace SevenSeals.Tss.Shared;

public abstract class ResponseBase: Proto
{
    public virtual long TimeStamp { get; set; } = 0;
}
