using System;

namespace SevenSeals.Tss.Codex;

public class TimeZoneRule : CodexBase
{
    public DayOfWeek DayOfWeek { get; set; }
    public TimeSpan StartTime { get; set; }
    public TimeSpan EndTime { get; set; }
    public bool IsActive { get; set; } = true;
    public List<Guid> AllowedAccessLevels { get; set; } = new();
    public List<Guid> ExcludedAccessLevels { get; set; } = new();
} 