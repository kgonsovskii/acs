using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class EventsResponse: ProtoResponse
{
    public required object Events { get; init; }
}
