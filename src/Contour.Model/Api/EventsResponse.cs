using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Api;

public class EventsResponse: ProtoResponse
{
    public required object Events { get; init; }
}
