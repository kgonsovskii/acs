namespace SevenSeals.Tss.Codex;

public class TimeZoneRule : CodexBase
{
    public DayOfWeek DayOfWeek { get; set; }
    public TimeSpan StartTime { get; set; }
    public TimeSpan EndTime { get; set; }
    public bool IsActive { get; set; } = true;
}
