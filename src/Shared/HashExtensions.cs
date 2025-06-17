using System.Reflection;
using System.Text.Json.Serialization;

namespace SevenSeals.Tss.Shared;

public static class HashExtensions
{
    public static T NewId<T>()
    {
        if (typeof(T) != typeof(Guid))
            throw new InvalidOperationException("T must be Guid");

        return (T)(object)(Guid.NewGuid());
    }

    public static T NewId<T>(string id)
    {
        if (typeof(T) != typeof(Guid))
            throw new InvalidOperationException("T must be Guid");

        return (T)(object)(Guid.Parse(id));
    }

    public static void AssignFrom(this object target, object source)
    {
        if (target == null) throw new ArgumentNullException(nameof(target));
        if (source == null) throw new ArgumentNullException(nameof(source));

        var targetType = target.GetType();
        var sourceType = source.GetType();

        var targetProps = targetType.GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Where(p => p.CanWrite);
        var sourceProps = sourceType.GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Where(p => p.CanRead);

        foreach (var targetProp in targetProps)
        {
            var sourceProp = sourceProps.FirstOrDefault(p =>
                p.Name == targetProp.Name &&
                p.PropertyType == targetProp.PropertyType);

            if (sourceProp != null)
            {
                var value = sourceProp.GetValue(source);
                targetProp.SetValue(target, value);
            }
        }
    }

    public static int GetProtoHash(this object obj)
    {
        if (obj == null)
            throw new ArgumentNullException(nameof(obj));

        var properties = obj.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Where(p => p.CanRead && !p.GetCustomAttributes<JsonIgnoreAttribute>().Any());

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
