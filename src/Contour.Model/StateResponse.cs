using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class StateResponse: ProtoResponse
{
    public required object State { get; init; }
}
