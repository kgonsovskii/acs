namespace SevenSeals.Tss.Codex.Services;
public interface IAccessLevelService
{
    Task<List<AccessLevel>> GetAccessLevelsAsync();
    Task<AccessLevel?> GetAccessLevelAsync(Guid id);
    Task<AccessLevel> CreateAccessLevelAsync(AccessLevel accessLevel);
    Task UpdateAccessLevelAsync(Guid id, AccessLevel accessLevel);
    Task DeleteAccessLevelAsync(Guid id);
    Task<bool> IsAccessLevelActiveAsync(Guid id);
}
public class AccessLevelService : IAccessLevelService
{
    private readonly CodexDbContext _context;

    public AccessLevelService(CodexDbContext context)
    {
        _context = context;
    }

    public async Task<List<AccessLevel>> GetAccessLevelsAsync()
    {
        return await _context.AccessLevels.ToListAsync();
    }

    public async Task<AccessLevel?> GetAccessLevelAsync(Guid id)
    {
        return await _context.AccessLevels.FindAsync(id);
    }

    public async Task<AccessLevel> CreateAccessLevelAsync(AccessLevel accessLevel)
    {
        accessLevel.Id = Guid.NewGuid();
        _context.AccessLevels.Add(accessLevel);
        await _context.SaveChangesAsync();
        return accessLevel;
    }

    public async Task UpdateAccessLevelAsync(Guid id, AccessLevel accessLevel)
    {
        var existingLevel = await _context.AccessLevels.FindAsync(id);
        if (existingLevel == null)
            throw new KeyNotFoundException($"AccessLevel with id {id} not found");

        existingLevel.Name = accessLevel.Name;
        existingLevel.Priority = accessLevel.Priority;
        existingLevel.IsActive = accessLevel.IsActive;

        await _context.SaveChangesAsync();
    }

    public async Task DeleteAccessLevelAsync(Guid id)
    {
        var accessLevel = await _context.AccessLevels.FindAsync(id);
        if (accessLevel == null)
            throw new KeyNotFoundException($"AccessLevel with id {id} not found");

        _context.AccessLevels.Remove(accessLevel);
        await _context.SaveChangesAsync();
    }

    public async Task<bool> IsAccessLevelActiveAsync(Guid id)
    {
        var accessLevel = await _context.AccessLevels.FindAsync(id);
        return accessLevel?.IsActive ?? false;
    }
}
