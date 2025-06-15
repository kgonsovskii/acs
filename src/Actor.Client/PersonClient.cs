using System.Net.Http.Json;

namespace SevenSeals.Tss.Actor;

public class ActorClient
{
    private readonly HttpClient _httpClient;
    private const string BaseUrl = "api/person";

    public ActorClient(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    #region Employees
    public async Task<List<Employee>> GetEmployeesAsync()
    {
        return await _httpClient.GetFromJsonAsync<List<Employee>>($"{BaseUrl}/employees") ?? new List<Employee>();
    }

    public async Task<Employee?> GetEmployeeAsync(Guid id)
    {
        return await _httpClient.GetFromJsonAsync<Employee>($"{BaseUrl}/employees/{id}");
    }

    public async Task<Employee> CreateEmployeeAsync(Employee employee)
    {
        var response = await _httpClient.PostAsJsonAsync($"{BaseUrl}/employees", employee);
        response.EnsureSuccessStatusCode();
        return await response.Content.ReadFromJsonAsync<Employee>() ?? throw new Exception("Failed to create employee");
    }

    public async Task UpdateEmployeeAsync(Guid id, Employee employee)
    {
        var response = await _httpClient.PutAsJsonAsync($"{BaseUrl}/employees/{id}", employee);
        response.EnsureSuccessStatusCode();
    }

    public async Task DeleteEmployeeAsync(Guid id)
    {
        var response = await _httpClient.DeleteAsync($"{BaseUrl}/employees/{id}");
        response.EnsureSuccessStatusCode();
    }

    public async Task<List<Employee>> GetEmployeesByDepartmentAsync(string department)
    {
        return await _httpClient.GetFromJsonAsync<List<Employee>>($"{BaseUrl}/employees/department/{department}") ?? new List<Employee>();
    }
    #endregion

    #region Keys
    public async Task<List<Key>> GetKeysAsync()
    {
        return await _httpClient.GetFromJsonAsync<List<Key>>($"{BaseUrl}/keys") ?? new List<Key>();
    }

    public async Task<Key?> GetKeyAsync(Guid id)
    {
        return await _httpClient.GetFromJsonAsync<Key>($"{BaseUrl}/keys/{id}");
    }

    public async Task<Key> CreateKeyAsync(Key key)
    {
        var response = await _httpClient.PostAsJsonAsync($"{BaseUrl}/keys", key);
        response.EnsureSuccessStatusCode();
        return await response.Content.ReadFromJsonAsync<Key>() ?? throw new Exception("Failed to create key");
    }

    public async Task UpdateKeyAsync(Guid id, Key key)
    {
        var response = await _httpClient.PutAsJsonAsync($"{BaseUrl}/keys/{id}", key);
        response.EnsureSuccessStatusCode();
    }

    public async Task DeleteKeyAsync(Guid id)
    {
        var response = await _httpClient.DeleteAsync($"{BaseUrl}/keys/{id}");
        response.EnsureSuccessStatusCode();
    }

    public async Task<List<Key>> GetKeysByPersonAsync(Guid personId)
    {
        return await _httpClient.GetFromJsonAsync<List<Key>>($"{BaseUrl}/keys/person/{personId}") ?? new List<Key>();
    }

    public async Task AssignKeyToPersonAsync(Guid keyId, Guid personId)
    {
        var response = await _httpClient.PostAsync($"{BaseUrl}/keys/{keyId}/assign/{personId}", null);
        response.EnsureSuccessStatusCode();
    }

    public async Task DeactivateKeyAsync(Guid keyId, KeyStatus status)
    {
        var response = await _httpClient.PostAsJsonAsync($"{BaseUrl}/keys/{keyId}/deactivate", status);
        response.EnsureSuccessStatusCode();
    }
    #endregion
}
