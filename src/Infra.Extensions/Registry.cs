using System.Collections.Concurrent;

namespace Infra;

public static class RegistryExtensions
{
    private static readonly ConcurrentDictionary<Type, string> ServiceGroupCache = new();

    public static string GetServiceGroup(this object baseObject, string? defaultValue = null)
    {
        var baseType = baseObject.GetType();
        return baseType.ServiceGroupByType(defaultValue);
    }

    private static string ServiceGroupByType(this Type baseType, string? defaultValue = null)
    {
        if (!string.IsNullOrEmpty(defaultValue))
            return defaultValue;
        return ServiceGroupCache.GetOrAdd(baseType, t =>
        {
            var x = t.FullName!.Split('.');
            if (x.Length <= 1)
                return defaultValue ?? throw new ArgumentNullException(nameof(defaultValue));
            return x[^2];
        });
    }

    public static string GetSchemaName(this Type type, string? defVal) => type.ServiceGroupByType(defVal).ToSnakeCase();
}
