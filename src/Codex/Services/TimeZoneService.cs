namespace SevenSeals.Tss.Codex.Services;
public interface ITimeZoneService
{
    Task<List<TimeZoneRule>> GetRulesAsync();
    Task<TimeZoneRule?> GetRuleAsync(Guid id);
    Task<TimeZoneRule> CreateRuleAsync(TimeZoneRule rule);
    Task UpdateRuleAsync(Guid id, TimeZoneRule rule);
    Task DeleteRuleAsync(Guid id);
    Task<bool> IsTimeZoneActiveAsync(Guid id);
}

public class TimeZoneService : ITimeZoneService
{
    private readonly CodexDbContext _context;

    public TimeZoneService(CodexDbContext context)
    {
        _context = context;
    }

    public async Task<List<TimeZoneRule>> GetRulesAsync()
    {
        return await _context.TimeZoneRules.ToListAsync();
    }

    public async Task<TimeZoneRule?> GetRuleAsync(Guid id)
    {
        return await _context.TimeZoneRules.FindAsync(id);
    }

    public async Task<TimeZoneRule> CreateRuleAsync(TimeZoneRule rule)
    {
        rule.Id = Guid.NewGuid();
        _context.TimeZoneRules.Add(rule);
        await _context.SaveChangesAsync();
        return rule;
    }

    public async Task UpdateRuleAsync(Guid id, TimeZoneRule rule)
    {
        var existingRule = await _context.TimeZoneRules.FindAsync(id);
        if (existingRule == null)
            throw new KeyNotFoundException($"TimeZoneRule with id {id} not found");

        existingRule.Name = rule.Name;
        existingRule.DayOfWeek = rule.DayOfWeek;
        existingRule.StartTime = rule.StartTime;
        existingRule.EndTime = rule.EndTime;
        existingRule.IsActive = rule.IsActive;

        await _context.SaveChangesAsync();
    }

    public async Task DeleteRuleAsync(Guid id)
    {
        var rule = await _context.TimeZoneRules.FindAsync(id);
        if (rule == null)
            throw new KeyNotFoundException($"TimeZoneRule with id {id} not found");

        _context.TimeZoneRules.Remove(rule);
        await _context.SaveChangesAsync();
    }

    public async Task<bool> IsTimeZoneActiveAsync(Guid id)
    {
        var rule = await _context.TimeZoneRules.FindAsync(id);
        if (rule == null || !rule.IsActive)
            return false;

        var now = DateTime.UtcNow;
        var currentTime = now.TimeOfDay;
        var currentDay = now.DayOfWeek;

        return rule.DayOfWeek == currentDay &&
               currentTime >= rule.StartTime &&
               currentTime <= rule.EndTime;
    }
}
