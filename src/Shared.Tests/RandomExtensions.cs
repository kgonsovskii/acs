using System.Reflection;

namespace Shared.Tests;

public static class RandomExtensions
{
    private static readonly Random Random = new();

    public static void FillWithRandomValues<T>(this T obj)
    {
        if (obj == null) throw new ArgumentNullException(nameof(obj));

        var properties = typeof(T)
            .GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Where(p => p.CanWrite);

        foreach (var prop in properties)
        {
            var value = GenerateRandomValue(prop.PropertyType);
            if (value != null)
            {
                prop.SetValue(obj, value);
            }
        }
    }

    private static object GenerateRandomValue(Type type)
    {
        if (type == typeof(int))
            return Random.Next();
        if (type == typeof(long))
            return ((long)Random.Next() << 32) | (uint)Random.Next();
        if (type == typeof(double))
            return Random.NextDouble();
        if (type == typeof(bool))
            return Random.Next(2) == 1;
        if (type == typeof(Guid))
            return Guid.NewGuid();
        if (type == typeof(string))
            return $"str_{Guid.NewGuid().ToString("N").Substring(0, 8)}";
        if (type == typeof(DateTime))
            return DateTime.UtcNow.AddSeconds(Random.Next(-1000000, 1000000));
        if (type == typeof(DateTimeOffset))
            return DateTimeOffset.UtcNow.AddSeconds(Random.Next(-1000000, 1000000));
        if (type.IsEnum)
        {
            var values = Enum.GetValues(type);
            return values.Length > 0 ? values.GetValue(Random.Next(values.Length)) : null;
        }

        // Nullable types
        if (Nullable.GetUnderlyingType(type) is Type underlyingType)
            return GenerateRandomValue(underlyingType);

        return null; // unsupported types
    }
}
