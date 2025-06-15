using System.Reflection;
using System.Text.Json.Serialization;

namespace SevenSeals.Tss.Shared;

public abstract class Proto
{
    /// <summary>
    /// Trace identifier for correlating requests.
    /// </summary>
    [JsonIgnore]
    public string TraceId { get; set; } = string.Empty;

    /// <summary>
    /// Agent with Machine-Code identifier for correlating requests.
    /// </summary>
    [JsonIgnore]
    public string Agent { get; set; } = string.Empty;

    [JsonIgnore]
    public int Chop { get; set; } = 1;

    [JsonIgnore]
    public virtual int Hash { get; set; } = 0;

    public virtual int GetHash()
    {
        var obj = this;
        if (obj == null)
            throw new ArgumentNullException(nameof(obj));

        var properties = obj.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Where(p => p.Name != nameof(Hash) && p.CanRead && !p.GetCustomAttributes<JsonIgnoreAttribute>().Any());

        unchecked
        {
            var hash = 17;
            foreach (var prop in properties)
            {
                var value = prop.GetValue(obj);
                hash = hash * 31 + (value?.GetHashCode() ?? 0);
            }
            return hash;
        }
    }
}
