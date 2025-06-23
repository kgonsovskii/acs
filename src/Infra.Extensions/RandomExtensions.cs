using System.Collections;
using System.Reflection;

namespace Infra;

public static class RandomExtensions
{
    private static readonly Random Random = new();

    public static void FillWithRandomValues<T>(this T obj)
    {
        if (obj == null) throw new ArgumentNullException(nameof(obj));

        var properties = obj.GetType()
            .GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Where(p => p.CanWrite).ToArray();

        foreach (var prop in properties)
        {
            var type = prop.PropertyType;
            // Nullable value type: всегда значение
            if (Nullable.GetUnderlyingType(type) is { } underlyingType)
            {
                type = underlyingType;
            }
            // string (nullable reference type): всегда строка
            if (type == typeof(string))
            {
                prop.SetValue(obj, GenerateRandomValue(type));
                continue;
            }
            // Примитивы, enum, Guid, DateTime, ...
            if (type.IsPrimitive || type.IsEnum || type == typeof(Guid) || type == typeof(DateTime) || type == typeof(DateTimeOffset) || type == typeof(TimeSpan) || type == typeof(byte[]))
            {
                var value = GenerateRandomValue(type);
                prop.SetValue(obj, value);
            }
            // Коллекции (List<T>, массивы)
            else if (type.IsArray)
            {
                var elemType = type.GetElementType()!;
                var length = Random.Next(1, 4);
                var array = Array.CreateInstance(elemType, length);
                for (int i = 0; i < length; i++)
                {
                    var elem = GenerateRandomValue(elemType);
                    if (elem == null && !elemType.IsPrimitive && elemType != typeof(string) && !elemType.IsEnum)
                    {
                        elem = Activator.CreateInstance(elemType);
                        elem.FillWithRandomValues();
                    }
                    array.SetValue(elem, i);
                }
                prop.SetValue(obj, array);
            }
            else if (type.IsGenericType && type.GetGenericTypeDefinition() == typeof(List<>))
            {
                var elemType = type.GetGenericArguments()[0];
                var length = Random.Next(1, 4);
                var list = (IList)Activator.CreateInstance(type)!;
                for (int i = 0; i < length; i++)
                {
                    var elem = GenerateRandomValue(elemType);
                    if (elem == null && !elemType.IsPrimitive && elemType != typeof(string) && !elemType.IsEnum)
                    {
                        elem = Activator.CreateInstance(elemType);
                        elem.FillWithRandomValues();
                    }
                    list.Add(elem);
                }
                prop.SetValue(obj, list);
            }
            // Nullable reference type (класс, не string, не массив, не коллекция): всегда объект
            else if (!type.IsValueType && !type.IsAbstract && type.GetConstructor(Type.EmptyTypes) != null)
            {
                var nested = Activator.CreateInstance(type);
                nested.FillWithRandomValues();
                prop.SetValue(obj, nested);
            }
        }
    }

    public static object? GenerateRandomValue(Type type)
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
        if (type == typeof(TimeSpan))
            return TimeSpan.FromSeconds(Random.Next(0, 86400)); // 0 to 24 hours in seconds
        if (type == typeof(byte[]))
        {
            var length = Random.Next(1, 17); // 1 to 16 bytes
            var bytes = new byte[length];
            Random.NextBytes(bytes);
            return bytes;
        }
        if (type == typeof(byte))
            return (byte)Random.Next(0, 256);
        if (type.IsEnum)
        {
            var values = Enum.GetValues(type);
            return values.Length > 0 ? values.GetValue(Random.Next(values.Length)) : null;
        }

        // Nullable types
        if (Nullable.GetUnderlyingType(type) is { } underlyingType)
            return GenerateRandomValue(underlyingType);

        return null; // unsupported types
    }
}
