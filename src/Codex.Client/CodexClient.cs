using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Codex;

public class CodexClient : CodexBaseClient
{
    public CodexClient(HttpClient httpClient, Settings settings, IOptions<CodexClientOptions> options, ILogger<CodexBaseClient> logger) 
        : base(httpClient, settings, options, logger)
    {
    }

    #region Routes
    public async Task<List<Route>> GetRoutesAsync()
    {
        return await GetAsync<List<Route>>("routes") ?? new List<Route>();
    }

    public async Task<Route?> GetRouteAsync(Guid id)
    {
        return await GetAsync<Route>($"routes/{id}");
    }

    public async Task<Route> CreateRouteAsync(Route route)
    {
        return await PostAsync<Route, Route>("routes", route);
    }

    public async Task UpdateRouteAsync(Guid id, Route route)
    {
        await PutAsync<Route, Route>($"routes/{id}", route);
    }

    public async Task DeleteRouteAsync(Guid id)
    {
        await DeleteAsync($"routes/{id}");
    }
    #endregion

    #region TimeZoneRules
    public async Task<List<TimeZoneRule>> GetTimeZoneRulesAsync()
    {
        return await GetAsync<List<TimeZoneRule>>("timezonerules") ?? new List<TimeZoneRule>();
    }

    public async Task<TimeZoneRule?> GetTimeZoneRuleAsync(Guid id)
    {
        return await GetAsync<TimeZoneRule>($"timezonerules/{id}");
    }

    public async Task<TimeZoneRule> CreateTimeZoneRuleAsync(TimeZoneRule rule)
    {
        return await PostAsync<TimeZoneRule, TimeZoneRule>("timezonerules", rule);
    }

    public async Task UpdateTimeZoneRuleAsync(Guid id, TimeZoneRule rule)
    {
        await PutAsync<TimeZoneRule, TimeZoneRule>($"timezonerules/{id}", rule);
    }

    public async Task DeleteTimeZoneRuleAsync(Guid id)
    {
        await DeleteAsync($"timezonerules/{id}");
    }
    #endregion

    #region AccessLevels
    public async Task<List<AccessLevel>> GetAccessLevelsAsync()
    {
        return await GetAsync<List<AccessLevel>>("accesslevels") ?? new List<AccessLevel>();
    }

    public async Task<AccessLevel?> GetAccessLevelAsync(Guid id)
    {
        return await GetAsync<AccessLevel>($"accesslevels/{id}");
    }

    public async Task<AccessLevel> CreateAccessLevelAsync(AccessLevel accessLevel)
    {
        return await PostAsync<AccessLevel, AccessLevel>("accesslevels", accessLevel);
    }

    public async Task UpdateAccessLevelAsync(Guid id, AccessLevel accessLevel)
    {
        await PutAsync<AccessLevel, AccessLevel>($"accesslevels/{id}", accessLevel);
    }

    public async Task DeleteAccessLevelAsync(Guid id)
    {
        await DeleteAsync($"accesslevels/{id}");
    }
    #endregion
}
