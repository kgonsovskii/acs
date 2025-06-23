namespace SevenSeals.Tss.Contour;

public class ContourOptions
{
    public bool AutoPoll { get; set; } = true;
    public TimeSpan PollTimeout { get; set; }
    public TimeSpan AliveTimeout { get; set; }
    public TimeSpan DeadTimeout { get; set; }
    public TimeSpan ResponseTimeout { get; set; }
}
