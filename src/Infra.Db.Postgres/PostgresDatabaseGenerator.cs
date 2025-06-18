using System.Reflection;
using System.Text;
using Infra.Extensions;

namespace Infra.Db;

public class PostgresDatabaseGenerator : IDatabaseGenerator
{
    private readonly ISchemaGenerator _schemaGenerator;

    public PostgresDatabaseGenerator(ISchemaGenerator schemaGenerator)
    {
        _schemaGenerator = schemaGenerator;
    }

    public string GenerateDatabaseSql(string outputDir)
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
        return GenerateDatabaseSqlForTypes(types);
    }

    public string GenerateDatabaseSqlForTypes(IList<Type> types)
    {
        var sbFinal = new StringBuilder();

        var schemaNames = new HashSet<string>();
        var allTypes = new List<Type>(types);
        var polymorphicTypes = new List<(Type ParentType, Type SubType, string TableName, string Schema)>();
        var childTableTypes = new List<(Type ParentType, Type ChildType, string TableName, string Schema, string ParentForeignKeyColumn, string ChildForeignKeyColumn)>();

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
                    var childType = GetChildTypeFromProperty(prop);
                    if (childType != null && childType.GetCustomAttribute<DbTableAttribute>() != null)
                    {
                        var childTableName = childAttr.GetTableName(type, childType);
                        var childSchema = childAttr.GetSchemaName(type);
                        var parentForeignKeyColumn = childAttr.GetForeignKeyColumnName(type);
                        var childForeignKeyColumn = childAttr.GetChildForeignKeyColumnName(type, childType, prop.Name);

                        childTableTypes.Add((type, childType, childTableName, childSchema, parentForeignKeyColumn, childForeignKeyColumn));
                        schemaNames.Add(childSchema);
                    }
                }
            }
        }

        var enumTypes = CollectEnumTypes(allTypes, polymorphicTypes, childTableTypes);

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
        sbFinal.AppendLine("      CREATE DATABASE acs OWNER tss;");
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
        var childTableSqls = new List<string>();
        var indexSqls = new List<string>();

        foreach (var type in types)
        {
            var tableAttr = type.GetCustomAttribute<DbTableAttribute>()!;
            var tableName = tableAttr.GetTableName(type);
            var schema = tableAttr.GetSchemaName(type);

            var tableSql = _schemaGenerator.GenerateCreateTableSql(type);
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
            sb.Append($"    \"{parentTableName}Id\" UUID REFERENCES \"{schema}\".\"{parentTableName}\"(\"{parentPkName}\"),\n");

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

        GenerateEnumForeignKeys(allTypes, polymorphicTypes, childTableTypes, enumForeignKeySqls);

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

    private void GenerateEnumForeignKeys(IList<Type> types, List<(Type ParentType, Type SubType, string TableName, string Schema)> polymorphicTypes, List<(Type ParentType, Type ChildType, string TableName, string Schema, string ParentForeignKeyColumn, string ChildForeignKeyColumn)> childTableTypes, List<string> enumForeignKeySqls)
    {
        foreach (var type in types)
        {
            var tableAttr = type.GetCustomAttribute<DbTableAttribute>()!;
            var tableName = tableAttr.GetTableName(type);
            var schema = tableAttr.GetSchemaName(type);

            foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                var propType = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
                if (!propType.IsEnum)
                    continue;
                var enumAttr = prop.GetCustomAttribute<DbEnumTableAttribute>();
                if (enumAttr == null)
                    continue;
                var enumTableName = enumAttr.GetTableName(propType);
                var enumSchema = enumAttr.GetSchemaName(propType);

                var fkSql = $"ALTER TABLE \"{schema}\".\"{tableName}\" ADD CONSTRAINT \"fk_{tableName}_{prop.Name.ToSnakeCase()}\" FOREIGN KEY (\"{prop.Name.ToSnakeCase()}\") REFERENCES \"{enumSchema}\".\"{enumTableName}\"(\"name\");";
                enumForeignKeySqls.Add(fkSql);
            }
        }

        foreach (var (_, subType, tableName, schema) in polymorphicTypes)
        {
            foreach (var prop in subType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                var propType = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
                if (!propType.IsEnum)
                    continue;
                var enumAttr = prop.GetCustomAttribute<DbEnumTableAttribute>();
                if (enumAttr == null)
                    continue;
                var enumTableName = enumAttr.GetTableName(propType);
                var enumSchema = enumAttr.GetSchemaName(propType);

                var fkSql = $"ALTER TABLE \"{schema}\".\"{tableName}\" ADD CONSTRAINT \"fk_{tableName}_{prop.Name.ToSnakeCase()}\" FOREIGN KEY (\"{prop.Name.ToSnakeCase()}\") REFERENCES \"{enumSchema}\".\"{enumTableName}\"(\"name\");";
                enumForeignKeySqls.Add(fkSql);
            }
        }

        foreach (var (_, childType, _, schema, _, _) in childTableTypes)
        {
            foreach (var prop in childType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                var propType = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
                if (!propType.IsEnum)
                    continue;
                var enumAttr = prop.GetCustomAttribute<DbEnumTableAttribute>();
                if (enumAttr == null)
                    continue;
                var enumTableName = enumAttr.GetTableName(propType);
                var enumSchema = enumAttr.GetSchemaName(propType);

                var fkSql = $"ALTER TABLE \"{schema}\".\"{childType.GetCustomAttribute<DbTableAttribute>()?.GetTableName(childType) ?? childType.Name.ToSnakeCase()}\" ADD CONSTRAINT \"fk_{childType.GetCustomAttribute<DbTableAttribute>()?.GetTableName(childType) ?? childType.Name.ToSnakeCase()}_{prop.Name.ToSnakeCase()}\" FOREIGN KEY (\"{prop.Name.ToSnakeCase()}\") REFERENCES \"{enumSchema}\".\"{enumTableName}\"(\"name\");";
                enumForeignKeySqls.Add(fkSql);
            }
        }
    }

    private static string GenerateColumnSqlForPoly(PropertyInfo prop)
    {
        var name = prop.Name.ToSnakeCase();
        var isNullable = IsNullableType(prop);
        var type = GetSqlTypeForPoly(prop);
        var nullable = isNullable ? " NULL" : " NOT NULL";
        var fkAttr = prop.GetCustomAttribute<DbForeignKeyAttribute>();
        var fk = fkAttr != null ? $" REFERENCES \"{fkAttr.ReferenceTable.ToSnakeCase()}\"(\"{fkAttr.ReferenceColumn.ToSnakeCase()}\")" : string.Empty;
        return $"    \"{name}\" {type}{nullable}{fk}";
    }

    private static bool IsNullableType(PropertyInfo prop)
    {
        var type = prop.PropertyType;

        if (Nullable.GetUnderlyingType(type) != null) return true;

        if (type.IsValueType)
            return false;
        var nullableAttribute = prop.GetCustomAttributes()
            .FirstOrDefault(attr => attr.GetType().Name == "NullableAttribute");

        return nullableAttribute != null;
    }

    private static List<Type> CollectEnumTypes(IList<Type> tableTypes, List<(Type ParentType, Type SubType, string TableName, string Schema)> polymorphicTypes, List<(Type ParentType, Type ChildType, string TableName, string Schema, string ParentForeignKeyColumn, string ChildForeignKeyColumn)> childTableTypes)
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
        if (underlyingType == typeof(DateTime)) return "DATETIME";
        if (underlyingType == typeof(bool)) return "BOOLEAN";
        if (underlyingType == typeof(double)) return "REAL";
        if (underlyingType == typeof(Guid)) return "UUID";
        if (underlyingType == typeof(byte)) return "SMALLINT";
        if (underlyingType == typeof(byte[])) return "BYTEA";
        if (underlyingType == typeof(TimeSpan)) return "INTERVAL";
        throw new NotSupportedException($"Type {prop.PropertyType.Name} is not supported");
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
        return assembly.GetTypes();
    }

    private Type? GetChildTypeFromProperty(PropertyInfo prop)
    {
        var propType = prop.PropertyType;

        if (propType.IsGenericType && propType.GetGenericTypeDefinition() == typeof(List<>))
        {
            return propType.GetGenericArguments()[0];
        }

        return propType.IsArray ? propType.GetElementType() : null;
    }
}
