namespace SevenSeals.Tss.Contour.Events;


public abstract class Event
{
    public DateTime Timestamp { get; } = DateTime.UtcNow;
    public abstract EventType Type { get; }
}
