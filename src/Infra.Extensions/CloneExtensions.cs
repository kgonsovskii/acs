using System.Collections;
using System.Reflection;
using System.Runtime.CompilerServices;

namespace Infra;

public static class CloneExtensions
{
    public static TTarget DeepBurn<TTarget>(this object source)
        where TTarget : class, new()
    {
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
        var visited = new Dictionary<object, object>(new ReferenceEqualityComparer())
        {
            [source] = target
        };
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

    public static bool IsSimilar(this object? obj1, object? obj2, out string notEqualFields)
    {
        notEqualFields = string.Empty;
        if (obj1 == null && obj2 == null) return true;
        if (obj1 == null || obj2 == null)
        {
            notEqualFields = "One of objects is null";
            return false;
        }
        var type1 = obj1.GetType();
        var type2 = obj2.GetType();
        var props1 = type1.GetProperties(BindingFlags.Public | BindingFlags.Instance);
        var props2 = type2.GetProperties(BindingFlags.Public | BindingFlags.Instance);
        var notEqual = new List<string>();
        foreach (var prop1 in props1)
        {
            if (!prop1.CanRead) continue;
            var prop2 = props2.FirstOrDefault(p => p.Name == prop1.Name);
            if (prop2 == null || !prop2.CanRead) continue;
            var val1 = prop1.GetValue(obj1);
            var val2 = prop2.GetValue(obj2);
            if (!AreValuesSimilar(val1, val2))
                notEqual.Add(prop1.Name);
        }
        notEqualFields = string.Join(", ", notEqual);
        return notEqual.Count == 0;
    }

    private static bool AreValuesSimilar(object? val1, object? val2)
    {
        if (val1 == null && val2 == null) return true;
        if (val1 == null || val2 == null) return false;
        if (val1.Equals(val2)) return true;
        // Deep compare for arrays and lists
        if (val1 is IEnumerable e1 && val2 is IEnumerable e2 && !(val1 is string) && !(val2 is string))
        {
            var list1 = e1.Cast<object?>().ToList();
            var list2 = e2.Cast<object?>().ToList();
            if (list1.Count != list2.Count) return false;
            for (int i = 0; i < list1.Count; i++)
            {
                if (!AreValuesSimilar(list1[i], list2[i]))
                    return false;
            }
            return true;
        }
        // Deep compare for complex objects
        var t1 = val1.GetType();
        var t2 = val2.GetType();
        if (!t1.IsPrimitive && !t1.IsEnum && t1 != typeof(string) && !t2.IsPrimitive && !t2.IsEnum && t2 != typeof(string))
        {
            return val1.IsSimilar(val2, out _);
        }
        return false;
    }
}
