using System.Reflection;
using System.Text;
using Infra.Db.Attributes;

namespace Infra.Db;

public class FirebirdDatabaseGenerator : IDatabaseGenerator
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
            sb.Append($"{schema}.");
        sb.Append($"{tableName} (\n");

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
        var fk = fkAttr != null ? $" REFERENCES {fkAttr.ReferenceSchema.ToSnakeCase()}.{fkAttr.ReferenceTable.ToSnakeCase()}({fkAttr.ReferenceColumn.ToSnakeCase()})" : string.Empty;
        return $"    {name} {type}{pk}{nullable}{fk}";
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
        if (type == typeof(int) || type == typeof(int?))
            return "INTEGER";
        if (type == typeof(long) || type == typeof(long?))
            return "BIGINT";
        if (type == typeof(short) || type == typeof(short?))
            return "SMALLINT";
        if (type == typeof(byte) || type == typeof(byte?))
            return "SMALLINT";
        if (type == typeof(bool) || type == typeof(bool?))
            return "SMALLINT"; // Firebird uses SMALLINT for boolean (0/1)
        if (type == typeof(string))
            return "VARCHAR(255)";
        if (type == typeof(char) || type == typeof(char?))
            return "CHAR(1)";
        if (type == typeof(DateTime) || type == typeof(DateTime?))
            return "TIMESTAMP";
        if (type == typeof(DateTimeOffset) || type == typeof(DateTimeOffset?))
            return "TIMESTAMP";
        if (type == typeof(TimeSpan) || type == typeof(TimeSpan?))
            return "TIME";
        if (type == typeof(DateOnly) || type == typeof(DateOnly?))
            return "DATE";
        if (type == typeof(TimeOnly) || type == typeof(TimeOnly?))
            return "TIME";
        if (type == typeof(decimal) || type == typeof(decimal?))
            return "DECIMAL(18,4)";
        if (type == typeof(double) || type == typeof(double?))
            return "DOUBLE PRECISION";
        if (type == typeof(float) || type == typeof(float?))
            return "FLOAT";
        if (type == typeof(Guid) || type == typeof(Guid?))
            return "CHAR(16) CHARACTER SET OCTETS";
        if (type == typeof(byte[]))
            return "BLOB";
        if (type.IsEnum)
            return "INTEGER";

        // Handle nullable types
        var underlyingType = Nullable.GetUnderlyingType(type);
        if (underlyingType != null)
            return GetSqlType(underlyingType, prop, isPrimaryKey);

        // Default to VARCHAR for unknown types
        return "VARCHAR(255)";
    }

    public string GenerateDatabaseSql(string outputDir)
    {
        var types = TypeCollector.CollectDbTableTypes(outputDir);
        return GenerateDatabaseSqlForTypes(types);
    }

    public string GenerateDatabaseSqlForTypes(IList<Type> types)
    {
        var sb = new StringBuilder();
        var polymorphicTypes = new List<(Type ParentType, Type SubType, string TableName, string Schema)>();
        var childTableTypes = new List<(Type ParentType, Type ChildType, string TableName, string Schema, string ParentForeignKeyColumn, string ChildForeignKeyColumn)>();
        var enumForeignKeySqls = new List<string>();
        var emittedConstraints = new HashSet<string>();

        // Generate main tables
        foreach (var type in types)
        {
            var tableAttr = type.GetCustomAttribute<DbTableAttribute>();
            if (tableAttr == null) continue;

            var tableName = tableAttr.GetTableName(type);
            var schema = tableAttr.GetSchemaName(type);

            // Generate main table
            sb.AppendLine(GenerateCreateTableSql(type));
            sb.AppendLine();

            // Generate polymorphic tables
            var allProperties = GetAllPropertiesInHierarchy(type);
            foreach (var prop in allProperties)
            {
                var polyAttr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
                if (polyAttr == null) continue;

                foreach (var subType in polyAttr.OptionTypes)
                {
                    var subName = subType.Name;
                    if (subName.EndsWith("Options"))
                        subName = subName.Substring(0, subName.Length - "Options".Length);
                    subName = subName.ToSnakeCase();
                    var subTable = $"{tableName}_{subName}";

                    sb.AppendLine($"CREATE TABLE {subTable} (");
                    sb.AppendLine($"    {tableName.ToSnakeCase()}_id INTEGER PRIMARY KEY,");
                    sb.AppendLine($"    {prop.Name.ToSnakeCase()} {GetSqlType(prop.PropertyType)}");
                    sb.AppendLine(");");
                    sb.AppendLine();

                    polymorphicTypes.Add((type, subType, subTable, schema));
                }
            }

            // Generate child tables
            foreach (var prop in allProperties)
            {
                var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
                if (childAttr == null) continue;

                var childType = prop.PropertyType;
                if (childType.IsGenericType && childType.GetGenericTypeDefinition() == typeof(List<>))
                {
                    childType = childType.GetGenericArguments()[0];
                }

                var childTableName = childAttr.GetTableName(prop, type);
                var childSchema = childAttr.GetSchemaName(type);

                sb.AppendLine($"CREATE TABLE {childTableName} (");
                sb.AppendLine($"    {tableName.ToSnakeCase()}_id INTEGER,");
                
                var childProps = childType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                var childColumns = childProps.Select(p => $"    {p.Name.ToSnakeCase()} {GetSqlType(p.PropertyType)}");
                sb.AppendLine(string.Join(",\n", childColumns));
                sb.AppendLine(");");
                sb.AppendLine();

                childTableTypes.Add((type, childType, childTableName, childSchema, $"{tableName.ToSnakeCase()}_id", "id"));
            }

            // Generate indexes
            GenerateIndexesForType(type, tableName, schema, sb);
        }

        // Generate foreign key constraints
        GenerateEnumForeignKeys(types, polymorphicTypes, childTableTypes, enumForeignKeySqls, emittedConstraints);

        foreach (var fkSql in enumForeignKeySqls)
        {
            sb.AppendLine(fkSql);
        }

        return sb.ToString();
    }

    private void GenerateIndexesForType(Type type, string tableName, string schema, StringBuilder sb)
    {
        var allProperties = GetAllPropertiesInHierarchy(type);
        
        // Generate indexes for foreign keys
        foreach (var prop in allProperties)
        {
            var fkAttr = prop.GetCustomAttribute<DbForeignKeyAttribute>();
            if (fkAttr != null)
            {
                var indexName = $"IX_{tableName}_{prop.Name.ToSnakeCase()}";
                sb.AppendLine($"CREATE INDEX {indexName} ON {tableName} ({prop.Name.ToSnakeCase()});");
            }
        }

        // Generate indexes for DbIndexAttribute
        foreach (var prop in allProperties)
        {
            var indexAttr = prop.GetCustomAttribute<DbIndexAttribute>();
            if (indexAttr != null)
            {
                var indexName = $"IX_{tableName}_{prop.Name.ToSnakeCase()}";
                var unique = indexAttr.IsUnique ? "UNIQUE " : "";
                sb.AppendLine($"CREATE {unique}INDEX {indexName} ON {tableName} ({prop.Name.ToSnakeCase()});");
            }
        }

        // Generate composite indexes for DbCompositeIndexAttribute
        var compositeIndexAttrs = type.GetCustomAttributes<DbCompositeIndexAttribute>();
        foreach (var compositeIndexAttr in compositeIndexAttrs)
        {
            var indexName = compositeIndexAttr.Name ?? $"IX_{tableName}_{string.Join("_", compositeIndexAttr.PropertyNames.Select(p => p.ToSnakeCase()))}";
            var unique = compositeIndexAttr.IsUnique ? "UNIQUE " : "";
            var columns = string.Join(", ", compositeIndexAttr.PropertyNames.Select(p => p.ToSnakeCase()));
            sb.AppendLine($"CREATE {unique}INDEX {indexName} ON {tableName} ({columns});");
        }
    }

    private void GenerateEnumForeignKeys(
        IList<Type> types,
        List<(Type ParentType, Type SubType, string TableName, string Schema)> polymorphicTypes,
        List<(Type ParentType, Type ChildType, string TableName, string Schema, string ParentForeignKeyColumn, string ChildForeignKeyColumn)> childTableTypes,
        List<string> enumForeignKeySqls,
        HashSet<string> emittedConstraints)
    {
        // Generate foreign key constraints for polymorphic tables
        foreach (var (parentType, subType, tableName, schema) in polymorphicTypes)
        {
            var parentTableAttr = parentType.GetCustomAttribute<DbTableAttribute>()!;
            var parentTableName = parentTableAttr.GetTableName(parentType);
            var constraintName = $"FK_{tableName}_{parentTableName}";
            
            if (!emittedConstraints.Contains(constraintName))
            {
                enumForeignKeySqls.Add($"ALTER TABLE {tableName} ADD CONSTRAINT {constraintName} FOREIGN KEY ({parentTableName.ToSnakeCase()}_id) REFERENCES {parentTableName}(id);");
                emittedConstraints.Add(constraintName);
            }
        }

        // Generate foreign key constraints for child tables
        foreach (var (parentType, childType, tableName, schema, parentFkColumn, childFkColumn) in childTableTypes)
        {
            var parentTableAttr = parentType.GetCustomAttribute<DbTableAttribute>()!;
            var parentTableName = parentTableAttr.GetTableName(parentType);
            var constraintName = $"FK_{tableName}_{parentTableName}";
            
            if (!emittedConstraints.Contains(constraintName))
            {
                enumForeignKeySqls.Add($"ALTER TABLE {tableName} ADD CONSTRAINT {constraintName} FOREIGN KEY ({parentFkColumn}) REFERENCES {parentTableName}(id);");
                emittedConstraints.Add(constraintName);
            }
        }

        // Generate foreign key constraints for regular foreign keys
        foreach (var type in types)
        {
            var tableAttr = type.GetCustomAttribute<DbTableAttribute>();
            if (tableAttr == null) continue;

            var tableName = tableAttr.GetTableName(type);
            var allProperties = GetAllPropertiesInHierarchy(type);

            foreach (var prop in allProperties)
            {
                var fkAttr = prop.GetCustomAttribute<DbForeignKeyAttribute>();
                if (fkAttr != null)
                {
                    var constraintName = $"FK_{tableName}_{prop.Name.ToSnakeCase()}";
                    if (!emittedConstraints.Contains(constraintName))
                    {
                        enumForeignKeySqls.Add($"ALTER TABLE {tableName} ADD CONSTRAINT {constraintName} FOREIGN KEY ({prop.Name.ToSnakeCase()}) REFERENCES {fkAttr.ReferenceTable.ToSnakeCase()}({fkAttr.ReferenceColumn.ToSnakeCase()});");
                        emittedConstraints.Add(constraintName);
                    }
                }
            }
        }
    }
} 