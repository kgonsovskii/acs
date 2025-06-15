using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class EventsResponse: ResponseBase
{
    public required object Events { get; init; }
}
