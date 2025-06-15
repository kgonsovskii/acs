namespace SevenSeals.Tss.Codex.Services;

public interface IRouteService
{
    Task<List<Route>> GetRoutesAsync();
    Task<Route?> GetRouteAsync(Guid id);
    Task<Route> CreateRouteAsync(Route route);
    Task UpdateRouteAsync(Guid id, Route route);
    Task DeleteRouteAsync(Guid id);
    Task<bool> IsRouteActiveAsync(Guid id);
}

public class RouteService : IRouteService
{
    private readonly CodexDbContext _context;

    public RouteService(CodexDbContext context)
    {
        _context = context;
    }

    public async Task<List<Route>> GetRoutesAsync()
    {
        return await _context.Routes.ToListAsync();
    }

    public async Task<Route?> GetRouteAsync(Guid id)
    {
        return await _context.Routes.FindAsync(id);
    }

    public async Task<Route> CreateRouteAsync(Route route)
    {
        route.Id = Guid.NewGuid();
        _context.Routes.Add(route);
        await _context.SaveChangesAsync();
        return route;
    }

    public async Task UpdateRouteAsync(Guid id, Route route)
    {
        var existingRoute = await _context.Routes.FindAsync(id);
        if (existingRoute == null)
            throw new KeyNotFoundException($"Route with id {id} not found");

        existingRoute.Name = route.Name;
        existingRoute.FromZoneId = route.FromZoneId;
        existingRoute.ToZoneId = route.ToZoneId;
        existingRoute.IsActive = route.IsActive;

        await _context.SaveChangesAsync();
    }

    public async Task DeleteRouteAsync(Guid id)
    {
        var route = await _context.Routes.FindAsync(id);
        if (route == null)
            throw new KeyNotFoundException($"Route with id {id} not found");

        _context.Routes.Remove(route);
        await _context.SaveChangesAsync();
    }

    public async Task<bool> IsRouteActiveAsync(Guid id)
    {
        var route = await _context.Routes.FindAsync(id);
        return route?.IsActive ?? false;
    }
}
