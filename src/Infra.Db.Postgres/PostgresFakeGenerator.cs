using System.Reflection;
using System.Text;
using Infra.Db.Attributes;

namespace Infra.Db;

public interface IFakeGenerator
{
    string GenerateFakeDataSql(string outputDir, Func<Type, bool>? onFilter = null);
    string GenerateFakeDataSqlForTypes(IList<Type> types, Func<Type, bool>? onFilter = null);
}

public class PostgresFakeGenerator : IFakeGenerator
{
    protected readonly TypeCollector TypeCollector = new();
    public string GenerateFakeDataSql(string outputDir, Func<Type, bool>? onFilter = null)
    {
        var types = TypeCollector.CollectDbTableTypes(outputDir);
        if (onFilter != null)
            types = types.Where(onFilter).ToList();
        return GenerateFakeDataSqlForTypes(types, onFilter);
    }

    public string GenerateFakeDataSqlForTypes(IList<Type> types, Func<Type, bool>? onFilter = null)
    {
        if (onFilter != null)
            types = types.Where(onFilter).ToList();
        var sb = new StringBuilder();
        var tableRows = new Dictionary<string, List<Dictionary<string, object?>>>();
        var tableSchemas = new Dictionary<string, (Type, string, string)>(); // key: schema.table, value: (type, schema, table)
        var parentIds = new Dictionary<string, List<object>>(); // For linking child/polymorphic tables
        var parentPolyValues = new Dictionary<string, List<Dictionary<string, object?>>?>(); // key: schema.table, value: list of dicts: propName -> value

        // Build dependency graph for tables based on foreign keys
        var dependencies = new Dictionary<string, HashSet<string>>();
        var typeByKey = new Dictionary<string, Type>();
        foreach (var type in types)
        {
            var tableAttr = type.GetCustomAttribute<DbTableAttribute>()!;
            var schema = tableAttr.GetSchemaName(type);
            var table = tableAttr.GetTableName(type);
            var key = $"{schema}.{table}";
            typeByKey[key] = type;
            dependencies[key] = new HashSet<string>();
            foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                var fkAttr = prop.GetCustomAttribute<DbForeignKeyAttribute>();
                if (fkAttr != null)
                {
                    var refSchema = fkAttr.ReferenceSchema.ToSnakeCase();
                    var refTable = fkAttr.ReferenceTable.ToSnakeCase();
                    var refKey = $"{refSchema}.{refTable}";
                    if (typeByKey.ContainsKey(refKey)) // Only add dependency if we generate that table
                        dependencies[key].Add(refKey);
                }
            }
        }
        // Topological sort
        var sortedKeys = new List<string>();
        var visited = new HashSet<string>();
        void Visit(string k)
        {
            if (visited.Contains(k)) return;
            visited.Add(k);
            foreach (var dep in dependencies[k])
                if (dependencies.ContainsKey(dep)) Visit(dep);
            sortedKeys.Add(k);
        }
        foreach (var k in dependencies.Keys) Visit(k);
        // Initialize tableSchemas, tableRows, parentIds, parentPolyValues for all tables in sortedKeys
        foreach (var key in sortedKeys)
        {
            var type = typeByKey[key];
            var tableAttr = type.GetCustomAttribute<DbTableAttribute>()!;
            var schema = tableAttr.GetSchemaName(type);
            var table = tableAttr.GetTableName(type);
            tableSchemas[key] = (type, schema, table);
            tableRows[key] = new List<Dictionary<string, object?>>();
            parentIds[key] = new List<object>();
            parentPolyValues[key] = new List<Dictionary<string, object?>>();
        }
        // Generate tables in sorted order
        foreach (var key in sortedKeys)
        {
            var (type, schema, table) = tableSchemas[key];
            var props = type.GetProperties(BindingFlags.Public | BindingFlags.Instance)
                .Where(p => p.GetCustomAttribute<DbPolymorphicTableAttribute>() == null &&
                           p.GetCustomAttribute<DbChildTableAttribute>() == null)
                .ToArray();
            var polyProps = type.GetProperties(BindingFlags.Public | BindingFlags.Instance)
                .Where(p => p.GetCustomAttribute<DbPolymorphicTableAttribute>() != null)
                .ToArray();
            for (int i = 0; i < 3; i++)
            {
                var row = new Dictionary<string, object?>();
                var polyVals = new Dictionary<string, object?>();
                foreach (var prop in props)
                {
                    object? value;
                    var fkAttr = prop.GetCustomAttribute<DbForeignKeyAttribute>();
                    if (fkAttr != null)
                    {
                        var refSchema = fkAttr.ReferenceSchema.ToSnakeCase();
                        var refTable = fkAttr.ReferenceTable.ToSnakeCase();
                        var refKey = $"{refSchema}.{refTable}";
                        if (parentIds.ContainsKey(refKey) && parentIds[refKey].Count > 0)
                        {
                            var refList = parentIds[refKey];
                            value = refList[new Random().Next(refList.Count)];
                        }
                        else
                        {
                            value = null;
                        }
                    }
                    else
                    {
                        value = GenerateRandomValueForProperty(prop);
                    }
                    row[prop.Name] = value;
                    if (prop.GetCustomAttribute<DbPrimaryKeyAttribute>() != null)
                    {
                        if (value != null) parentIds[key].Add(value);
                    }
                }
                foreach (var polyProp in polyProps)
                {
                    var value = GenerateRandomValueForPolymorphicProperty(polyProp);
                    polyVals[polyProp.Name] = value;
                }
                tableRows[key].Add(row);
                parentPolyValues[key]!.Add(polyVals);
            }
        }

        // 2. Polymorphic tables
        foreach (var (type, schema, table) in tableSchemas.Values.ToList())
        {
            foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                var polyAttr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
                if (polyAttr != null)
                {
                    foreach (var subType in polyAttr.OptionTypes)
                    {
                        var subName = subType.Name;
                        if (subName.EndsWith("Options"))
                            subName = subName.Substring(0, subName.Length - "Options".Length);
                        subName = subName.ToSnakeCase();
                        var subTable = $"{table}_{subName}";
                        var subKey = $"{schema}.{subTable}";
                        tableSchemas[subKey] = (subType, schema, subTable);
                        tableRows[subKey] = new List<Dictionary<string, object?>>();
                        var parentKey = $"{schema}.{table}";
                        for (int i = 0; i < tableRows[parentKey].Count; i++)
                        {
                            var parentId = parentIds[parentKey][i % parentIds[parentKey].Count];
                            var polyVals = parentPolyValues[parentKey]![i];
                            if (!polyVals.TryGetValue(prop.Name, out var polyValue) || polyValue == null)
                                continue;
                            var realType = polyValue.GetType();
                            if (!subType.IsAssignableFrom(realType))
                                continue;
                            var row = new Dictionary<string, object?>();
                            var parentTableName = table;
                            var parentRefCol = $"{parentTableName}Id".ToSnakeCase();
                            row[parentRefCol] = parentId;
                            foreach (var subProp in subType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
                            {
                                row[subProp.Name] = subProp.GetValue(polyValue);
                            }
                            tableRows[subKey].Add(row);
                        }
                    }
                }
            }
        }

        // 3. Child tables (simple and complex)
        foreach (var (type, schema, table) in tableSchemas.Values.ToList())
        {
            foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
                if (childAttr != null)
                {
                    var childType = GetChildTypeFromProperty(prop);
                    if (childType != null)
                    {
                        bool isSimple = childType == typeof(string) || childType == typeof(int) || childType == typeof(long) || childType == typeof(Guid) || childType == typeof(double) || childType == typeof(bool) || childType == typeof(byte);
                        var childTable = childAttr.GetTableName(prop, type);
                        var childSchema = childAttr.GetSchemaName(type);
                        var childKey = $"{childSchema}.{childTable}";
                        tableSchemas[childKey] = (childType, childSchema, childTable);
                        tableRows[childKey] = new List<Dictionary<string, object?>>();
                        for (int i = 0; i < 2; i++)
                        {
                            var row = new Dictionary<string, object?>();
                            var parentRefCol = childAttr.GetForeignKeyColumnName(type).ToSnakeCase();
                            var parentId = parentIds[$"{schema}.{table}"][i % parentIds[$"{schema}.{table}"].Count];
                            row[parentRefCol] = parentId;
                            if (isSimple)
                            {
                                var valueColumn = prop.Name.EndsWith("es") ? prop.Name.Substring(0, prop.Name.Length - 2) : (prop.Name.EndsWith("s") ? prop.Name.Substring(0, prop.Name.Length - 1) : prop.Name);
                                valueColumn = valueColumn.ToSnakeCase();
                                row[valueColumn] = GenerateRandomValue(childType);
                            }
                            else if (childType.GetCustomAttribute<DbTableAttribute>() != null)
                            {
                                // Link to child
                                var childPkProp = childType.GetProperties().FirstOrDefault(p => p.GetCustomAttribute<DbPrimaryKeyAttribute>() != null);
                                var childId = GenerateRandomValue(childPkProp?.PropertyType ?? typeof(Guid));
                                row[childAttr.GetChildForeignKeyColumnName(type, childType, prop.Name)] = childId;
                            }
                            tableRows[childKey].Add(row);
                        }
                    }
                }
            }
        }

        // Emit INSERTs
        foreach (var (key, rows) in tableRows)
        {
            var (_, schema, table) = tableSchemas[key];
            if (rows.Count == 0) continue;
            var columns = rows[0].Keys.ToList();
            foreach (var row in rows)
            {
                var colList = string.Join(", ", columns.Select(c => $"\"{c.ToSnakeCase()}\""));
                var valList = string.Join(", ", columns.Select(c => SqlValue(row[c])));
                sb.AppendLine($"INSERT INTO \"{schema}\".\"{table}\" ({colList}) VALUES ({valList});");
            }
        }
        return sb.ToString();
    }

    private static object? GenerateRandomValueForProperty(PropertyInfo prop)
    {
        var type = prop.PropertyType;
        if (Nullable.GetUnderlyingType(type) != null)
            type = Nullable.GetUnderlyingType(type)!;
        if (type.IsEnum)
        {
            var values = Enum.GetValues(type);
            return values.Length > 0 ? values.GetValue(new Random().Next(values.Length)) : null;
        }
        return RandomExtensions.GenerateRandomValue(type);
    }

    private static object? GenerateRandomValue(Type type)
    {
        if (Nullable.GetUnderlyingType(type) != null)
            type = Nullable.GetUnderlyingType(type)!;
        if (type.IsEnum)
        {
            var values = Enum.GetValues(type);
            return values.Length > 0 ? values.GetValue(new Random().Next(values.Length)) : null;
        }

        return RandomExtensions.GenerateRandomValue(type);
    }

    private static string SqlValue(object? value)
    {
        if (value == null) return "NULL";
        if (value is string s) return $"'{s.Replace("'", "''")}'";
        if (value is Guid g) return $"'{g}'";
        if (value is DateTime dt) return $"'{dt:yyyy-MM-dd HH:mm:ss}'";
        if (value is TimeSpan ts) return $"'{ts:hh\\:mm\\:ss}'";
        if (value is bool b) return b ? "TRUE" : "FALSE";
        if (value is Enum e) return $"'{e.ToString().ToSnakeCase()}'";
        if (value is byte[] ba) return $"'\\x{BitConverter.ToString(ba).Replace("-", string.Empty).ToLower()}'";
        return value.ToString()!;
    }

    private static IEnumerable<Assembly> LoadAssembliesFromDirectory(string directory)
    {
        var dlls = Directory.GetFiles(directory, "*.dll");
        foreach (var dll in dlls)
        {
            yield return Assembly.LoadFrom(dll);
        }
    }

    private static IEnumerable<Type> SafeGetTypes(Assembly assembly)
    {
        try { return assembly.GetTypes(); } catch { return Array.Empty<Type>(); }
    }

    private static Type? GetChildTypeFromProperty(PropertyInfo prop)
    {
        var propType = prop.PropertyType;
        if (propType.IsGenericType && propType.GetGenericTypeDefinition() == typeof(List<>))
            return propType.GetGenericArguments()[0];
        return propType.IsArray ? propType.GetElementType() : null;
    }

    private static object? GenerateRandomValueForPolymorphicProperty(PropertyInfo prop)
    {
        var attr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
        if (attr == null || attr.OptionTypes.Length == 0)
            return null;
        var type = attr.OptionTypes[new Random().Next(attr.OptionTypes.Length)];
        var instance = Activator.CreateInstance(type);
        var typeProp = type.GetProperty("Type");
        if (typeProp != null && typeProp.CanWrite && typeProp.PropertyType.IsEnum)
        {
            var enumName = type.Name.Replace("Options", "");
            var enumType = typeProp.PropertyType;
            if (Enum.TryParse(enumType, enumName, ignoreCase: true, out var enumValue))
            {
                typeProp.SetValue(instance, enumValue);
            }
        }
        foreach (var subProp in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
        {
            if (subProp.Name == "Type" && subProp.PropertyType.IsEnum) continue;
            var value = GenerateRandomValueForProperty(subProp);
            subProp.SetValue(instance, value);
        }
        return instance;
    }
}
