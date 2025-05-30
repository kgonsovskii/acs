namespace SevenSeals.Tss.Contour;


public class SpotOptions
{
    public int TcpPort { get; set; }
    public TimeSpan AliveTimeout { get; set; }
    public TimeSpan DeadTimeout { get; set; }
    public TimeSpan ResponseTimeout { get; set; }
}
