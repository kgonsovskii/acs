namespace SevenSeals.Tss.Contour.Events;

public class QueueFullEvent : Event
{
    public override EventType Type => EventType.QueueFull;
}
