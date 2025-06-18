using System.Collections.Concurrent;

namespace Infra.Extensions;

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
        return ServiceGroupCache.GetOrAdd(baseType, t =>
        {
            if (t.FullName!.Contains("SevenSeals"))
                return t.FullName!.Split('.')[2].ToLowerInvariant();
            var assemblies = AppDomain.CurrentDomain.GetAssemblies();
            foreach (var asm in assemblies)
            {
                if (asm.GetName().Name!.StartsWith("Shared"))
                    continue;

                var derivedType = asm.GetTypes()
                    .FirstOrDefault(tt => tt is { IsClass: true, IsAbstract: false } && t.IsAssignableFrom(tt));

                if (derivedType != null)
                {
                    return derivedType.Assembly.GetName().Name!.Split('.')[0];
                }
            }

            if (defaultValue== null)
                throw new Exception("No test service found for this test");
            return defaultValue;
        });
    }

    public static string GetSchemaName(this Type type, string? defVal) => type.ServiceGroupByType(defVal);
}
