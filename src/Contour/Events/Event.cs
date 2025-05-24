namespace SevenSeals.Tss.Contour.Events;


public abstract class Event
{
    public DateTime Timestamp { get; } = DateTime.UtcNow;

    public virtual EventType Type { get; set; }
}
