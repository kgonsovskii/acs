namespace SevenSeals.Tss.Contour;

public class ContourOptions
{
    public bool AutoPoll { get; set; } = true;
    public TimeSpan AliveTimeout { get; set; }
    public TimeSpan DeadTimeout { get; set; }
    public TimeSpan ResponseTimeout { get; set; }
}
