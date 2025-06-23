using System.ComponentModel;
using SevenSeals.Tss.Contour.Api;

namespace SevenSeals.Tss.Contour.Diagnostic;

public class MainClientRequest: ContourRequest
{
    [DefaultValue(true)]
    public bool IsMainClient { get; set; } = true;

    [DefaultValue(1000)]
    public int QueueLimit { get; set; } = 1000;
}
