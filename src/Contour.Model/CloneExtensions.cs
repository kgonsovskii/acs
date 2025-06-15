using System.Collections;
using System.Reflection;
using System.Runtime.CompilerServices;

namespace SevenSeals.Tss.Contour;

public static class CloneExtensions
{
    public static TTarget DeepBurn<TTarget>(this object source)
        where TTarget : class, new()
    {
        if (source == null) return null!;
        var target = new TTarget();
        source.DeepCopy(target);
        return target;
    }

    public static T DeepClone<T>(this T source)
    {
        if (source == null) return default!;
        var visited = new Dictionary<object, object>(new ReferenceEqualityComparer());
        return (T)CloneObject(source, visited);
    }

    public static void DeepCopy<TSource, TTarget>(this TSource source, TTarget target)
        where TSource : class
        where TTarget : class
    {
        if (source == null || target == null) return;

        var visited = new Dictionary<object, object>(new ReferenceEqualityComparer());
        visited[source] = target;
        CopyProperties(source, target, visited);
    }

    private static object CloneObject(object source, Dictionary<object, object> visited)
    {
        if (source == null) return null!;
        var type = source.GetType();

        if (type.IsPrimitive || type.IsEnum || type == typeof(string) || type.IsValueType)
            return source;

        if (visited.TryGetValue(source, out var existingCopy))
            return existingCopy;

        if (type.IsArray)
        {
            var array = (Array)source;
            var cloned = (Array)Activator.CreateInstance(type, array.Length)!;
            visited[source] = cloned;

            for (var i = 0; i < array.Length; i++)
                cloned.SetValue(CloneObject(array.GetValue(i)!, visited), i);

            return cloned;
        }

        if (typeof(IList).IsAssignableFrom(type))
        {
            var listType = type.IsInterface ? typeof(List<>).MakeGenericType(type.GetGenericArguments()) : type;
            var list = (IList)Activator.CreateInstance(listType)!;
            visited[source] = list;

            foreach (var item in (IEnumerable)source)
                list.Add(CloneObject(item, visited));

            return list;
        }

        if (typeof(IDictionary).IsAssignableFrom(type))
        {
            var dictType = type.IsInterface ? typeof(Dictionary<,>).MakeGenericType(type.GetGenericArguments()) : type;
            var dict = (IDictionary)Activator.CreateInstance(dictType)!;
            visited[source] = dict;

            foreach (DictionaryEntry entry in (IDictionary)source)
                dict.Add(CloneObject(entry.Key, visited), CloneObject(entry.Value!, visited));

            return dict;
        }

        var clone = Activator.CreateInstance(type)!;
        visited[source] = clone;

        CopyProperties(source, clone, visited);
        return clone;
    }

    private static void CopyProperties(object source, object target, Dictionary<object, object> visited)
    {
        var sourceType = source.GetType();
        var targetType = target.GetType();

        foreach (var prop in sourceType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
        {
            if (!prop.CanRead) continue;

            var targetProp = targetType.GetProperty(prop.Name, BindingFlags.Public | BindingFlags.Instance);
            if (targetProp == null || !targetProp.CanWrite)
                continue;

            var value = prop.GetValue(source);
            if (value == null)
            {
                targetProp.SetValue(target, null);
                continue;
            }

            var propType = prop.PropertyType;

            if (propType.IsPrimitive || propType.IsEnum || propType == typeof(string) || propType.IsValueType)
            {
                targetProp.SetValue(target, value);
            }
            else
            {
                // Recurse
                if (visited.TryGetValue(value, out var existing))
                {
                    targetProp.SetValue(target, existing);
                }
                else
                {
                    object? nestedClone;

                    if (targetProp.PropertyType.IsAssignableFrom(propType))
                    {
                        nestedClone = CloneObject(value, visited);
                    }
                    else
                    {
                        // Incompatible types — skip or throw if strict
                        continue;
                    }

                    visited[value] = nestedClone!;
                    targetProp.SetValue(target, nestedClone);
                }
            }
        }
    }

    private class ReferenceEqualityComparer : IEqualityComparer<object>
    {
        public new bool Equals(object? x, object? y) => ReferenceEquals(x, y);
        public int GetHashCode(object obj) => RuntimeHelpers.GetHashCode(obj);
    }
}
