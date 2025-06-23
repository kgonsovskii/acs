using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Contour.Events;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Logic.Api;

public class CallBackRequest: ProtoRequest
{
    public ContourSnapshot ContourSnapshot { get; set; }
}

public class CallBackResponse : ProtoResponse
{

}
