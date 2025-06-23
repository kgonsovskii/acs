using System.Reflection;
using Infra.Db.Attributes;

namespace Infra.Db;

public class TypeCollector
{
    private static IEnumerable<Assembly> LoadAssembliesFromDirectory(string directory)
    {
        var dlls = Directory.GetFiles(directory, "*.dll");
        foreach (var dll in dlls)
        {
            yield return Assembly.LoadFrom(dll);
        }
    }

    public Type? GetChildTypeFromProperty(PropertyInfo prop)
    {
        var propType = prop.PropertyType;

        if (propType.IsGenericType && propType.GetGenericTypeDefinition() == typeof(List<>))
        {
            return propType.GetGenericArguments()[0];
        }

        return propType.IsArray ? propType.GetElementType() : null;
    }

    private static IEnumerable<Type> SafeGetTypes(Assembly assembly)
    {
        return assembly.GetTypes();
    }

    public List<Type> CollectDbTableTypes(string outputDir)
    {
        var types = new List<Type>();
        var assemblies = LoadAssembliesFromDirectory(outputDir);
        foreach (var assembly in assemblies)
        {
            var assemblyTypes = SafeGetTypes(assembly);
            foreach (var type in assemblyTypes)
            {
                if (type.GetCustomAttribute<DbTableAttribute>() != null)
                {
                    types.Add(type);
                }
            }
        }
        return SortTypesByDependencies(types);
    }

    private List<Type> SortTypesByDependencies(List<Type> types)
    {
        var result = new List<Type>();
        var processed = new HashSet<Type>();
        var withForeignKeys = new HashSet<Type>();

        // First pass - identify types with foreign keys
        foreach (var type in types)
        {
            var hasFk = false;
            foreach (var prop in type.GetProperties())
            {
                if (prop.GetCustomAttribute<DbForeignKeyAttribute>() != null)
                {
                    hasFk = true;
                    break;
                }
            }
            if (hasFk)
            {
                withForeignKeys.Add(type);
            }
        }

        // Add types without foreign keys first
        foreach (var type in types)
        {
            if (!withForeignKeys.Contains(type))
            {
                result.Add(type);
                processed.Add(type);
            }
        }

        // Add types with foreign keys
        foreach (var type in types)
        {
            if (!processed.Contains(type))
            {
                result.Add(type);
            }
        }

        return result;
    }

    public List<Type> CollectEnumTypes(IList<Type> tableTypes, List<(Type ParentType, Type SubType, string TableName, string Schema)> polymorphicTypes, List<(Type ParentType, Type ChildType, string TableName, string Schema, string ParentForeignKeyColumn, string ChildForeignKeyColumn)> childTableTypes)
    {
        var enumTypes = new HashSet<Type>();

        foreach (var type in tableTypes)
        {
            foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                var propType = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
                if (!propType.IsEnum)
                    continue;
                var enumAttr = prop.GetCustomAttribute<DbEnumTableAttribute>();
                if (enumAttr != null)
                {
                    enumTypes.Add(propType);
                }
            }
        }

        foreach (var (_, subType, _, _) in polymorphicTypes)
        {
            foreach (var prop in subType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                var propType = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
                if (!propType.IsEnum)
                    continue;
                var enumAttr = prop.GetCustomAttribute<DbEnumTableAttribute>();
                if (enumAttr != null)
                {
                    enumTypes.Add(propType);
                }
            }
        }

        foreach (var (_, childType, _, _, _, _) in childTableTypes)
        {
            foreach (var prop in childType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                var propType = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
                if (!propType.IsEnum)
                    continue;
                var enumAttr = prop.GetCustomAttribute<DbEnumTableAttribute>();
                if (enumAttr != null)
                {
                    enumTypes.Add(propType);
                }
            }
        }

        return enumTypes.ToList();
    }
}
