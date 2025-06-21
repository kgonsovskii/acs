using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Api;

public class StateResponse: ProtoResponse
{
    public required object State { get; init; }
}
