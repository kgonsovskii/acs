namespace SevenSeals.Tss.Shared.Model;

public class StatusResponse: ResponseBase
{
    public string Service { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;

    public string TimeStamp { get; set; } = string.Empty;
}
