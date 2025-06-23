using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Api;

public class StateResponse: ProtoStateResponse
{
    public required ContourSnapshot State { get; init; }
}
