using System.Reflection;
using System.Text;
using Infra.Extensions;

namespace Infra.Db;


public class PostgresSchemaGenerator : ISchemaGenerator
{
    public string GenerateCreateTableSql(Type type)
    {
        var tableAttr = type.GetCustomAttribute<DbTableAttribute>();
        if (tableAttr == null)
            throw new InvalidOperationException($"Type {type.Name} does not have TableAttribute");
        var tableName = tableAttr.GetTableName(type);
        var schema = tableAttr.GetSchemaName(type);
        var sb = new StringBuilder();
        sb.Append($"CREATE TABLE ");
        if (!string.IsNullOrEmpty(schema))
            sb.Append($"\"{schema}\".");
        sb.Append($"\"{tableName}\" (\n");
        var props = type.GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Where(p => p.GetCustomAttribute<DbPolymorphicTableAttribute>() == null &&
                       p.GetCustomAttribute<DbChildTableAttribute>() == null)
            .GroupBy(p => p.Name)
            .Select(g => g.First()) // Take the first property with each name (most derived)
            .ToArray();
        var columns = props.Select(p => GenerateColumnSql(p)).ToList();
        sb.Append(string.Join(",\n", columns));
        sb.Append("\n);");
        return sb.ToString();
    }

    private string GenerateColumnSql(PropertyInfo prop)
    {
        var name = prop.Name.ToSnakeCase();
        var isPrimaryKey = prop.GetCustomAttribute<DbPrimaryKeyAttribute>() != null;
        var isNullable = IsNullableType(prop);
        var type = GetSqlType(prop.PropertyType, prop, isPrimaryKey);
        var pk = isPrimaryKey ? " PRIMARY KEY" : string.Empty;
        var nullable = isNullable ? " NULL" : " NOT NULL";
        var fkAttr = prop.GetCustomAttribute<DbForeignKeyAttribute>();
        var fk = fkAttr != null ? $" REFERENCES \"{fkAttr.ReferenceTable.ToSnakeCase()}\"(\"{fkAttr.ReferenceColumn.ToSnakeCase()}\")" : string.Empty;
        return $"    \"{name}\" {type}{pk}{nullable}{fk}";
    }

    private static bool IsNullableType(PropertyInfo prop)
    {
        var type = prop.PropertyType;

        if (Nullable.GetUnderlyingType(type) != null) return true;

        if (type.IsValueType) return false;
        var nullableAttribute = prop.GetCustomAttributes()
            .FirstOrDefault(attr => attr.GetType().Name == "NullableAttribute");

        return nullableAttribute != null;
    }

    private string GetSqlType(Type type, PropertyInfo? prop = null, bool isPrimaryKey = false)
    {
        var underlyingType = Nullable.GetUnderlyingType(type) ?? type;

        if ((underlyingType == typeof(string[]) ||
             (underlyingType.IsGenericType && underlyingType.GetGenericTypeDefinition() == typeof(List<>) && underlyingType.GetGenericArguments()[0] == typeof(string))))
        {
            if (prop != null && prop.GetCustomAttribute<DbCsvStringAttribute>() != null)
                return "TEXT";
            throw new NotSupportedException($"Type {type.Name} is not supported unless CsvStringAttribute is present");
        }

        switch (isPrimaryKey)
        {
            case true when underlyingType == typeof(int):
                return "SERIAL";
            case true when underlyingType == typeof(long):
                return "BIGSERIAL";
        }

        if (underlyingType == typeof(int)) return "INTEGER";
        if (underlyingType == typeof(long)) return "BIGINT";
        if (underlyingType == typeof(string)) return "TEXT";
        if (underlyingType == typeof(DateTime)) return "DATETIME";
        if (underlyingType == typeof(bool)) return "BOOLEAN";
        if (underlyingType == typeof(double)) return "REAL";
        if (underlyingType == typeof(Guid)) return "UUID";
        if (underlyingType == typeof(byte)) return "SMALLINT";
        if (underlyingType == typeof(byte[])) return "BYTEA";
        if (underlyingType == typeof(TimeSpan)) return "INTERVAL";
        if (underlyingType.IsEnum) return "TEXT";
        throw new NotSupportedException($"Type {type.Name} is not supported");
    }
}
