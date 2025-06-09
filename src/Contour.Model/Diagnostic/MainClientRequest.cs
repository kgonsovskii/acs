using System.ComponentModel;

namespace SevenSeals.Tss.Contour.Diagnostic;

public class MainClientRequest: SpotRequest
{
    [DefaultValue(true)]
    public bool IsMainClient { get; set; } = true;

    [DefaultValue(1000)]
    public int QueueLimit { get; set; } = 1000;
}
