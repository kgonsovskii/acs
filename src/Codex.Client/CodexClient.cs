using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Json;
using System.Threading.Tasks;
using SevenSeals.Tss.Codex;

namespace SevenSeals.Tss.Codex.Client;

public class CodexClient
{
    private readonly HttpClient _httpClient;
    private const string BaseUrl = "api/codex";

    public CodexClient(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    #region Routes
    public async Task<List<Route>> GetRoutesAsync()
    {
        return await _httpClient.GetFromJsonAsync<List<Route>>($"{BaseUrl}/routes") ?? new List<Route>();
    }

    public async Task<Route?> GetRouteAsync(Guid id)
    {
        return await _httpClient.GetFromJsonAsync<Route>($"{BaseUrl}/routes/{id}");
    }

    public async Task<Route> CreateRouteAsync(Route route)
    {
        var response = await _httpClient.PostAsJsonAsync($"{BaseUrl}/routes", route);
        response.EnsureSuccessStatusCode();
        return await response.Content.ReadFromJsonAsync<Route>() ?? throw new Exception("Failed to create route");
    }

    public async Task UpdateRouteAsync(Guid id, Route route)
    {
        var response = await _httpClient.PutAsJsonAsync($"{BaseUrl}/routes/{id}", route);
        response.EnsureSuccessStatusCode();
    }

    public async Task DeleteRouteAsync(Guid id)
    {
        var response = await _httpClient.DeleteAsync($"{BaseUrl}/routes/{id}");
        response.EnsureSuccessStatusCode();
    }
    #endregion

    #region TimeZoneRules
    public async Task<List<TimeZoneRule>> GetTimeZoneRulesAsync()
    {
        return await _httpClient.GetFromJsonAsync<List<TimeZoneRule>>($"{BaseUrl}/timezonerules") ?? new List<TimeZoneRule>();
    }

    public async Task<TimeZoneRule?> GetTimeZoneRuleAsync(Guid id)
    {
        return await _httpClient.GetFromJsonAsync<TimeZoneRule>($"{BaseUrl}/timezonerules/{id}");
    }

    public async Task<TimeZoneRule> CreateTimeZoneRuleAsync(TimeZoneRule rule)
    {
        var response = await _httpClient.PostAsJsonAsync($"{BaseUrl}/timezonerules", rule);
        response.EnsureSuccessStatusCode();
        return await response.Content.ReadFromJsonAsync<TimeZoneRule>() ?? throw new Exception("Failed to create time zone rule");
    }

    public async Task UpdateTimeZoneRuleAsync(Guid id, TimeZoneRule rule)
    {
        var response = await _httpClient.PutAsJsonAsync($"{BaseUrl}/timezonerules/{id}", rule);
        response.EnsureSuccessStatusCode();
    }

    public async Task DeleteTimeZoneRuleAsync(Guid id)
    {
        var response = await _httpClient.DeleteAsync($"{BaseUrl}/timezonerules/{id}");
        response.EnsureSuccessStatusCode();
    }
    #endregion

    #region AccessLevels
    public async Task<List<AccessLevel>> GetAccessLevelsAsync()
    {
        return await _httpClient.GetFromJsonAsync<List<AccessLevel>>($"{BaseUrl}/accesslevels") ?? new List<AccessLevel>();
    }

    public async Task<AccessLevel?> GetAccessLevelAsync(Guid id)
    {
        return await _httpClient.GetFromJsonAsync<AccessLevel>($"{BaseUrl}/accesslevels/{id}");
    }

    public async Task<AccessLevel> CreateAccessLevelAsync(AccessLevel accessLevel)
    {
        var response = await _httpClient.PostAsJsonAsync($"{BaseUrl}/accesslevels", accessLevel);
        response.EnsureSuccessStatusCode();
        return await response.Content.ReadFromJsonAsync<AccessLevel>() ?? throw new Exception("Failed to create access level");
    }

    public async Task UpdateAccessLevelAsync(Guid id, AccessLevel accessLevel)
    {
        var response = await _httpClient.PutAsJsonAsync($"{BaseUrl}/accesslevels/{id}", accessLevel);
        response.EnsureSuccessStatusCode();
    }

    public async Task DeleteAccessLevelAsync(Guid id)
    {
        var response = await _httpClient.DeleteAsync($"{BaseUrl}/accesslevels/{id}");
        response.EnsureSuccessStatusCode();
    }
    #endregion
} 