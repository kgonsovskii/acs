using System.Reflection;
using System.Text;
using Infra.Db.Attributes;

namespace Infra.Db;

public class PostgresDatabaseGenerator : IDatabaseGenerator
{
   protected readonly TypeCollector TypeCollector = new();
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

        // Get all properties from the type and its base types
        var allProperties = GetAllPropertiesInHierarchy(type);
        var props = allProperties
            .Where(p => p.GetCustomAttribute<DbPolymorphicTableAttribute>() == null &&
                       p.GetCustomAttribute<DbChildTableAttribute>() == null)
            .GroupBy(p => p.Name)
            .Select(g => GetMostDerivedProperty(g)) // Get the most derived property
            .ToArray();

        var columns = props.Select(p => GenerateColumnSql(p)).ToList();
        sb.Append(string.Join(",\n", columns));
        sb.Append("\n);");
        return sb.ToString();
    }

    private static IEnumerable<PropertyInfo> GetAllPropertiesInHierarchy(Type type)
    {
        var properties = new List<PropertyInfo>();
        var currentType = type;

        while (currentType != null && currentType != typeof(object))
        {
            var typeProperties = currentType.GetProperties(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly);
            properties.AddRange(typeProperties);
            currentType = currentType.BaseType;
        }

        return properties;
    }

    private static PropertyInfo GetMostDerivedProperty(IGrouping<string, PropertyInfo> group)
    {
        // Sort by declaring type hierarchy (most derived first)
        var sortedProperties = group.OrderByDescending(p => GetTypeDepth(p.DeclaringType!)).ToList();
        return sortedProperties.First();
    }

    private static int GetTypeDepth(Type type)
    {
        int depth = 0;
        var currentType = type;

        while (currentType != null && currentType != typeof(object))
        {
            depth++;
            currentType = currentType.BaseType;
        }

        return depth;
    }

    public string GenerateColumnSql(PropertyInfo prop)
    {
        var name = prop.Name.ToSnakeCase();
        var isPrimaryKey = prop.GetCustomAttribute<DbPrimaryKeyAttribute>() != null;
        var isNullable = IsNullableType(prop);
        var type = GetSqlType(prop.PropertyType, prop, isPrimaryKey);
        var pk = isPrimaryKey ? " PRIMARY KEY" : string.Empty;
        var nullable = isNullable ? " NULL" : " NOT NULL";
        var fkAttr = prop.GetCustomAttribute<DbForeignKeyAttribute>();
        var fk = fkAttr != null ? $" REFERENCES \"{fkAttr.ReferenceSchema.ToSnakeCase()}\".\"{fkAttr.ReferenceTable.ToSnakeCase()}\"(\"{fkAttr.ReferenceColumn.ToSnakeCase()}\")" : string.Empty;
        return $"    \"{name}\" {type}{pk}{nullable}{fk}";
    }

    public bool IsNullableType(PropertyInfo prop)
    {
        // Check for nullable value types (int?, Guid?, etc.)
        if (Nullable.GetUnderlyingType(prop.PropertyType) != null)
            return true;

        // Check for explicit DbNull attribute
        if (prop.GetCustomAttribute<DbNullAttribute>() != null)
            return true;

        // All other fields are NOT NULL by default
        return false;
    }

    public string GetSqlType(Type type, PropertyInfo? prop = null, bool isPrimaryKey = false)
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
        if (underlyingType == typeof(DateTime)) return "TIMESTAMP";
        if (underlyingType == typeof(bool)) return "BOOLEAN";
        if (underlyingType == typeof(double)) return "REAL";
        if (underlyingType == typeof(Guid)) return "UUID";
        if (underlyingType == typeof(byte)) return "SMALLINT";
        if (underlyingType == typeof(byte[])) return "BYTEA";
        if (underlyingType == typeof(TimeSpan)) return "INTERVAL";
        if (underlyingType.IsEnum) return "TEXT";
        throw new NotSupportedException($"Type {type.Name} is not supported");
    }

    private static string GetSqlTypeForPoly(PropertyInfo prop)
    {
        var underlyingType = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;

        if ((underlyingType == typeof(string[])) ||
            (underlyingType.IsGenericType && underlyingType.GetGenericTypeDefinition() == typeof(List<>) && underlyingType.GetGenericArguments()[0] == typeof(string)))
        {
            if (prop.GetCustomAttribute<DbCsvStringAttribute>() != null)
                return "TEXT";
            throw new NotSupportedException($"Type {prop.PropertyType.Name} is not supported unless CsvStringAttribute is present");
        }
        if (underlyingType.IsEnum) return "TEXT";
        if (underlyingType == typeof(int)) return "INTEGER";
        if (underlyingType == typeof(long)) return "BIGINT";
        if (underlyingType == typeof(string)) return "TEXT";
        if (underlyingType == typeof(DateTime)) return "TIMESTAMP";
        if (underlyingType == typeof(bool)) return "BOOLEAN";
        if (underlyingType == typeof(double)) return "REAL";
        if (underlyingType == typeof(Guid)) return "UUID";
        if (underlyingType == typeof(byte)) return "SMALLINT";
        if (underlyingType == typeof(byte[])) return "BYTEA";
        if (underlyingType == typeof(TimeSpan)) return "INTERVAL";
        throw new NotSupportedException($"Type {prop.PropertyType.Name} is not supported");
    }

    public string GenerateDatabaseSql(string outputDir)
    {
        var types = TypeCollector.CollectDbTableTypes(outputDir);
        return GenerateDatabaseSqlForTypes(types);
    }

    public string GenerateDatabaseSqlForTypes(IList<Type> types)
    {
        var sbFinal = new StringBuilder();
        var childTableSqls = new List<string>();

        var schemaNames = new HashSet<string>();
        var allTypes = new List<Type>(types);
        var polymorphicTypes = new List<(Type ParentType, Type SubType, string TableName, string Schema)>();
        var childTableTypes = new List<(Type ParentType, Type ChildType, string TableName, string Schema, string ParentForeignKeyColumn, string ChildForeignKeyColumn)>();
        var emittedConstraints = new HashSet<string>();

        foreach (var type in types)
        {
            var tableAttr = type.GetCustomAttribute<DbTableAttribute>()!;
            var schema = tableAttr.GetSchemaName(type);
            schemaNames.Add(schema);

            foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                var polyAttr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
                if (polyAttr != null)
                {
                    for (int i = 0; i < polyAttr.OptionTypes.Length; i++)
                    {
                        var subType = polyAttr.OptionTypes[i];
                        var subName = subType.Name;
                        if (subName.EndsWith("Options"))
                            subName = subName.Substring(0, subName.Length - "Options".Length);
                        subName = subName.ToSnakeCase();
                        var subTable = $"{tableAttr.GetTableName(type)}_{subName}";
                        var subSchema = schema;

                        polymorphicTypes.Add((type, subType, subTable, subSchema));
                        schemaNames.Add(subSchema);
                    }
                }

                var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
                if (childAttr != null)
                {
                    var childType = TypeCollector.GetChildTypeFromProperty(prop);
                    if (childType != null)
                    {
                        // Check if simple type (string, int, Guid, etc.)
                        bool isSimple = childType == typeof(string) || childType == typeof(int) || childType == typeof(long) || childType == typeof(Guid) || childType == typeof(double) || childType == typeof(bool) || childType == typeof(byte);
                        if (isSimple)
                        {
                            var childTableName = childAttr.GetTableName(prop, type);
                            var childSchema = childAttr.GetSchemaName(type);
                            var parentForeignKeyColumn = childAttr.GetForeignKeyColumnName(type);
                            var valueColumn = prop.Name.EndsWith("es") ? prop.Name.Substring(0, prop.Name.Length - 2) : (prop.Name.EndsWith("s") ? prop.Name.Substring(0, prop.Name.Length - 1) : prop.Name);
                            valueColumn = valueColumn.ToSnakeCase();
                            var valueType = childType == typeof(string) ? "TEXT" : childType == typeof(int) ? "INTEGER" : childType == typeof(long) ? "BIGINT" : childType == typeof(Guid) ? "UUID" : childType == typeof(double) ? "REAL" : childType == typeof(bool) ? "BOOLEAN" : childType == typeof(byte) ? "SMALLINT" : "TEXT";
                            var sb = new StringBuilder();
                            sb.Append($"CREATE TABLE IF NOT EXISTS \"{childSchema}\".\"{childTableName}\" (\n");
                            sb.Append($"    \"{parentForeignKeyColumn}\" UUID REFERENCES \"{schema}\".\"{tableAttr.GetTableName(type)}\"(\"id\"),\n");
                            sb.Append($"    \"{valueColumn}\" {valueType} NOT NULL\n");
                            sb.Append(");");
                            childTableSqls.Add(sb.ToString());
                            schemaNames.Add(childSchema);
                        }
                        else if (childType.GetCustomAttribute<DbTableAttribute>() != null)
                        {
                            var childTableName = childAttr.GetTableName(prop, type);
                            var childSchema = childAttr.GetSchemaName(type);
                            var parentForeignKeyColumn = childAttr.GetForeignKeyColumnName(type);
                            var childForeignKeyColumn = childAttr.GetChildForeignKeyColumnName(type, childType, prop.Name);

                            childTableTypes.Add((type, childType, childTableName, childSchema, parentForeignKeyColumn, childForeignKeyColumn));
                            schemaNames.Add(childSchema);
                        }
                    }
                }
            }
        }

        var enumTypes = TypeCollector.CollectEnumTypes(allTypes, polymorphicTypes, childTableTypes);

        var enumTableSqls = new List<string>();
        var enumInsertSqls = new List<string>();
        var enumForeignKeySqls = new List<string>();

        foreach (var enumType in enumTypes)
        {
            var firstProperty = allTypes.SelectMany(t => t.GetProperties())
                .Concat(polymorphicTypes.SelectMany(pt => pt.SubType.GetProperties()))
                .Concat(childTableTypes.SelectMany(ct => ct.ChildType.GetProperties()))
                .FirstOrDefault(p => (Nullable.GetUnderlyingType(p.PropertyType) ?? p.PropertyType) == enumType &&
                                   p.GetCustomAttribute<DbEnumTableAttribute>() != null);
            if (firstProperty != null)
            {
                var enumAttr = firstProperty.GetCustomAttribute<DbEnumTableAttribute>()!;
                var tableName = enumAttr.GetTableName(enumType);
                var schema = enumAttr.GetSchemaName(enumType);
                schemaNames.Add(schema);

                var sb = new StringBuilder();
                sb.Append($"CREATE TABLE IF NOT EXISTS \"{schema}\".\"{tableName}\" (\n");
                sb.Append($"    \"name\" TEXT PRIMARY KEY");
                if (!string.IsNullOrEmpty(enumAttr.DescriptionColumnName))
                {
                    sb.Append($",\n    \"{enumAttr.DescriptionColumnName}\" TEXT");
                }
                sb.Append("\n);");
                enumTableSqls.Add(sb.ToString());

                var values = Enum.GetValues(enumType);
                foreach (var value in values)
                {
                    var enumValue = (Enum)value;
                    var insertSb = new StringBuilder();
                    insertSb.Append($"INSERT INTO \"{schema}\".\"{tableName}\" (\"name\"");
                    if (!string.IsNullOrEmpty(enumAttr.DescriptionColumnName))
                    {
                        insertSb.Append($", \"{enumAttr.DescriptionColumnName}\"");
                    }
                    insertSb.Append($") VALUES ('{enumValue.ToString().ToSnakeCase()}'");
                    if (!string.IsNullOrEmpty(enumAttr.DescriptionColumnName))
                    {
                        insertSb.Append($", '{enumValue.ToString()}'");
                    }
                    insertSb.Append(") ON CONFLICT (\"name\") DO NOTHING;");
                    enumInsertSqls.Add(insertSb.ToString());
                }
            }
        }

        sbFinal.AppendLine("DO $$");
        sbFinal.AppendLine("BEGIN");
        sbFinal.AppendLine("   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'tss') THEN");
        sbFinal.AppendLine("      CREATE USER tss WITH PASSWORD '123' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN;");
        sbFinal.AppendLine("   END IF;");
        sbFinal.AppendLine("END$$;");
        sbFinal.AppendLine();

        sbFinal.AppendLine("DO $$");
        sbFinal.AppendLine("BEGIN");
        sbFinal.AppendLine("   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'acs') THEN");
        sbFinal.AppendLine("      CREATE DATABASE acs OWNER tss ENCODING 'UTF8' LC_COLLATE='ru_RU.UTF-8' LC_CTYPE='ru_RU.UTF-8' TEMPLATE template0;");
        sbFinal.AppendLine("   END IF;");
        sbFinal.AppendLine("END$$;");
        sbFinal.AppendLine();

        sbFinal.AppendLine("ALTER DATABASE acs OWNER TO tss;");
        sbFinal.AppendLine("GRANT ALL PRIVILEGES ON DATABASE acs TO tss;");
        sbFinal.AppendLine("GRANT CREATE ON DATABASE acs TO tss;");
        sbFinal.AppendLine();

        sbFinal.AppendLine("\\c acs tss");
        sbFinal.AppendLine();

        foreach (var schemaName in schemaNames.OrderBy(s => s))
        {
            sbFinal.AppendLine($"CREATE SCHEMA IF NOT EXISTS \"{schemaName}\" AUTHORIZATION tss;");
        }
        sbFinal.AppendLine();

        var tableSqls = new List<string>();
        var polyTableSqls = new List<string>();
        var indexSqls = new List<string>();

        foreach (var type in types)
        {
            var tableAttr = type.GetCustomAttribute<DbTableAttribute>()!;
            var tableName = tableAttr.GetTableName(type);
            var schema = tableAttr.GetSchemaName(type);

            var tableSql = GenerateCreateTableSql(type);
            tableSqls.Add(tableSql);

            GenerateIndexesForType(type, tableName, schema, indexSqls);
        }

        foreach (var (parentType, subType, tableName, schema) in polymorphicTypes)
        {
            var parentTableAttr = parentType.GetCustomAttribute<DbTableAttribute>()!;
            var parentTableName = parentTableAttr.GetTableName(parentType);
            var parentPkProp = parentType.GetProperties().FirstOrDefault(p => p.GetCustomAttribute<DbPrimaryKeyAttribute>() != null);
            var parentPkName = parentPkProp?.Name.ToSnakeCase() ?? "id";

            var subProps = subType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
            var sb = new StringBuilder();
            sb.Append($"CREATE TABLE IF NOT EXISTS \"{schema}\".\"{tableName}\" (\n");
            sb.Append($"    \"{parentTableName}_id\" UUID REFERENCES \"{schema}\".\"{parentTableName}\"(\"{parentPkName}\"),\n");

            var columns = subProps.Select(p => GenerateColumnSqlForPoly(p));
            sb.Append(string.Join(",\n", columns));
            sb.Append("\n);");
            polyTableSqls.Add(sb.ToString());

            GenerateIndexesForType(subType, tableName, schema, indexSqls, $"{parentTableName}Id");
        }

        foreach (var (parentType, childType, tableName, schema, parentForeignKeyColumn, childForeignKeyColumn) in childTableTypes)
        {
            var parentTableAttr = parentType.GetCustomAttribute<DbTableAttribute>()!;
            var parentTableName = parentTableAttr.GetTableName(parentType);
            var parentPkProp = parentType.GetProperties().FirstOrDefault(p => p.GetCustomAttribute<DbPrimaryKeyAttribute>() != null);
            var parentPkName = parentPkProp?.Name.ToSnakeCase() ?? "id";

            var childTableAttr = childType.GetCustomAttribute<DbTableAttribute>()!;
            var childTableName = childTableAttr.GetTableName(childType);
            var childPkProp = childType.GetProperties().FirstOrDefault(p => p.GetCustomAttribute<DbPrimaryKeyAttribute>() != null);
            var childPkName = childPkProp?.Name.ToSnakeCase() ?? "id";

            var sb = new StringBuilder();
            sb.Append($"CREATE TABLE IF NOT EXISTS \"{schema}\".\"{tableName}\" (\n");
            sb.Append($"    \"{parentForeignKeyColumn}\" UUID REFERENCES \"{schema}\".\"{parentTableName}\"(\"{parentPkName}\"),\n");
            sb.Append($"    \"{childForeignKeyColumn}\" UUID REFERENCES \"{schema}\".\"{childTableName}\"(\"{childPkName}\"),\n");
            sb.Append($"    PRIMARY KEY (\"{parentForeignKeyColumn}\", \"{childForeignKeyColumn}\")\n");
            sb.Append(");");
            childTableSqls.Add(sb.ToString());

            indexSqls.Add($"CREATE INDEX IF NOT EXISTS \"idx_{tableName}_{parentForeignKeyColumn}\" ON \"{schema}\".\"{tableName}\"(\"{parentForeignKeyColumn}\");");
            indexSqls.Add($"CREATE INDEX IF NOT EXISTS \"idx_{tableName}_{childForeignKeyColumn}\" ON \"{schema}\".\"{tableName}\"(\"{childForeignKeyColumn}\");");
        }

        GenerateEnumForeignKeys(allTypes, polymorphicTypes, childTableTypes, enumForeignKeySqls, emittedConstraints);

        sbFinal.AppendLine("-- Enum tables");
        foreach (var sql in enumTableSqls)
        {
            sbFinal.AppendLine(sql);
            sbFinal.AppendLine();
        }

        sbFinal.AppendLine("-- Regular tables");
        foreach (var sql in tableSqls)
        {
            sbFinal.AppendLine(sql);
            sbFinal.AppendLine();
        }

        sbFinal.AppendLine("-- Polymorphic tables");
        foreach (var sql in polyTableSqls)
        {
            sbFinal.AppendLine(sql);
            sbFinal.AppendLine();
        }

        sbFinal.AppendLine("-- Child tables");
        foreach (var sql in childTableSqls)
        {
            sbFinal.AppendLine(sql);
            sbFinal.AppendLine();
        }

        sbFinal.AppendLine("-- Indexes");
        foreach (var sql in indexSqls)
        {
            sbFinal.AppendLine(sql);
        }
        sbFinal.AppendLine();

        sbFinal.AppendLine("-- Enum data population");
        foreach (var sql in enumInsertSqls)
        {
            sbFinal.AppendLine(sql);
        }
        sbFinal.AppendLine();

        sbFinal.AppendLine("-- Enum foreign keys");
        foreach (var sql in enumForeignKeySqls)
        {
            sbFinal.AppendLine(sql);
        }

        return sbFinal.ToString();
    }

    private void GenerateIndexesForType(Type type, string tableName, string schema, List<string> indexSqls, string? additionalColumn = null)
    {
        foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
        {
            var indexAttr = prop.GetCustomAttribute<DbIndexAttribute>();
            if (indexAttr != null)
            {
                var indexName = indexAttr.Name ?? $"idx_{tableName}_{prop.Name.ToSnakeCase()}";
                var unique = indexAttr.IsUnique ? "UNIQUE " : "";
                var columns = $"\"{prop.Name.ToSnakeCase()}\"";
                if (additionalColumn != null)
                {
                    columns = $"\"{additionalColumn}\", {columns}";
                }
                indexSqls.Add($"CREATE {unique}INDEX IF NOT EXISTS \"{indexName}\" ON \"{schema}\".\"{tableName}\"({columns});");
            }
        }

        var compositeIndexAttrs = type.GetCustomAttributes<DbCompositeIndexAttribute>();
        foreach (var compositeIndexAttr in compositeIndexAttrs)
        {
            var indexName = compositeIndexAttr.Name ?? $"idx_{tableName}_{string.Join("_", compositeIndexAttr.PropertyNames.Select(p => p.ToSnakeCase()))}";
            var unique = compositeIndexAttr.IsUnique ? "UNIQUE " : "";
            var columns = string.Join(", ", compositeIndexAttr.PropertyNames.Select(p => $"\"{p.ToSnakeCase()}\""));
            if (additionalColumn != null)
            {
                columns = $"\"{additionalColumn}\", {columns}";
            }
            indexSqls.Add($"CREATE {unique}INDEX IF NOT EXISTS \"{indexName}\" ON \"{schema}\".\"{tableName}\"({columns});");
        }
    }

    private void GenerateEnumForeignKeys(
        IList<Type> types,
        List<(Type ParentType, Type SubType, string TableName, string Schema)> polymorphicTypes,
        List<(Type ParentType, Type ChildType, string TableName, string Schema, string ParentForeignKeyColumn, string ChildForeignKeyColumn)> childTableTypes,
        List<string> enumForeignKeySqls,
        HashSet<string> emittedConstraints)
    {
        foreach (var type in types)
        {
            var tableAttr = type.GetCustomAttribute<DbTableAttribute>()!;
            var tableName = tableAttr.GetTableName(type);
            var schema = tableAttr.GetSchemaName(type);
            foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                var propType = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
                if (!propType.IsEnum) continue;
                var enumAttr = prop.GetCustomAttribute<DbEnumTableAttribute>();
                if (enumAttr == null) continue;
                var enumTableName = enumAttr.GetTableName(propType);
                var enumSchema = enumAttr.GetSchemaName(propType);
                var constraintName = $"fk_{tableName}_{prop.Name.ToSnakeCase()}";
                if (!emittedConstraints.Add($"{schema}.{tableName}.{constraintName}")) continue;
                var fkSql = $"ALTER TABLE \"{schema}\".\"{tableName}\" ADD CONSTRAINT \"{constraintName}\" FOREIGN KEY (\"{prop.Name.ToSnakeCase()}\") REFERENCES \"{enumSchema}\".\"{enumTableName}\"(\"name\");";
                enumForeignKeySqls.Add(fkSql);
            }
        }
        foreach (var (_, subType, tableName, schema) in polymorphicTypes)
        {
            foreach (var prop in subType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                var propType = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
                if (!propType.IsEnum) continue;
                var enumAttr = prop.GetCustomAttribute<DbEnumTableAttribute>();
                if (enumAttr == null) continue;
                var enumTableName = enumAttr.GetTableName(propType);
                var enumSchema = enumAttr.GetSchemaName(propType);
                var constraintName = $"fk_{tableName}_{prop.Name.ToSnakeCase()}";
                if (!emittedConstraints.Add($"{schema}.{tableName}.{constraintName}")) continue;
                var fkSql = $"ALTER TABLE \"{schema}\".\"{tableName}\" ADD CONSTRAINT \"{constraintName}\" FOREIGN KEY (\"{prop.Name.ToSnakeCase()}\") REFERENCES \"{enumSchema}\".\"{enumTableName}\"(\"name\");";
                enumForeignKeySqls.Add(fkSql);
            }
        }
        foreach (var (_, childType, _, schema, _, _) in childTableTypes)
        {
            var childTableAttr = childType.GetCustomAttribute<DbTableAttribute>();
            var childTableName = childTableAttr?.GetTableName(childType) ?? childType.Name.ToSnakeCase();
            foreach (var prop in childType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                var propType = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
                if (!propType.IsEnum) continue;
                var enumAttr = prop.GetCustomAttribute<DbEnumTableAttribute>();
                if (enumAttr == null) continue;
                var enumTableName = enumAttr.GetTableName(propType);
                var enumSchema = enumAttr.GetSchemaName(propType);
                var constraintName = $"fk_{childTableName}_{prop.Name.ToSnakeCase()}";
                if (!emittedConstraints.Add($"{schema}.{childTableName}.{constraintName}")) continue;
                var fkSql = $"ALTER TABLE \"{schema}\".\"{childTableName}\" ADD CONSTRAINT \"{constraintName}\" FOREIGN KEY (\"{prop.Name.ToSnakeCase()}\") REFERENCES \"{enumSchema}\".\"{enumTableName}\"(\"name\");";
                enumForeignKeySqls.Add(fkSql);
            }
        }
    }

    private string GenerateColumnSqlForPoly(PropertyInfo prop)
    {
        var name = prop.Name.ToSnakeCase();
        var isNullable = IsNullableType(prop);
        var type = GetSqlTypeForPoly(prop);
        var nullable = isNullable ? " NULL" : " NOT NULL";
        var fkAttr = prop.GetCustomAttribute<DbForeignKeyAttribute>();
        var fk = fkAttr != null ? $" REFERENCES \"{fkAttr.ReferenceTable.ToSnakeCase()}\"(\"{fkAttr.ReferenceColumn.ToSnakeCase()}\")" : string.Empty;
        return $"    \"{name}\" {type}{nullable}{fk}";
    }
}
