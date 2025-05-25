using SevenSeals.Tss.Shared;

namespace Contour.Application;

public class StatusResponse: ResponseBase
{
    public string Status { get; set; } = string.Empty;

    public string TimeStamp { get; set; } = string.Empty;
}
