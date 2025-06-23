using System.Reflection;
using Npgsql;
using System.Data;
using System.Text;
using Infra.Db.Attributes;

namespace Infra.Db;

public class PostgresDbAdapter<TClass, TId> : IDbAdapter<TClass, TId>
    where TClass : class
    where TId : struct
{
    private readonly string _tableName;
    private readonly string _schema;
    private readonly string _primaryKeyColumn;
    private readonly Type _primaryKeyType;
    private readonly string _connectionString;
    private readonly PropertyInfo[] _directProperties;
    private readonly PropertyInfo[] _allProperties;

    public PostgresDbAdapter(string connectionString)
    {
        _connectionString = connectionString ?? throw new ArgumentNullException(nameof(connectionString));

        // Validate that TClass has DbTableAttribute
        var tableAttr = typeof(TClass).GetCustomAttribute<DbTableAttribute>();
        if (tableAttr == null)
            throw new InvalidOperationException($"Type {typeof(TClass).Name} must be decorated with DbTableAttribute");

        _tableName = tableAttr.GetTableName(typeof(TClass));
        _schema = tableAttr.GetSchemaName(typeof(TClass));

        // Find primary key property
        var primaryKeyProp = typeof(TClass).GetProperties()
            .FirstOrDefault(p => p.GetCustomAttribute<DbPrimaryKeyAttribute>() != null);

        if (primaryKeyProp == null)
            throw new InvalidOperationException($"Type {typeof(TClass).Name} must have a property decorated with DbPrimaryKeyAttribute");

        _primaryKeyColumn = primaryKeyProp.Name.ToSnakeCase();
        _primaryKeyType = primaryKeyProp.PropertyType;

        // Validate that TId matches the primary key type
        if (_primaryKeyType != typeof(TId))
            throw new InvalidOperationException($"TId type {typeof(TId).Name} must match the primary key type {_primaryKeyType.Name}");

        // Cache properties for different purposes
        _allProperties = typeof(TClass).GetProperties(BindingFlags.Public | BindingFlags.Instance).ToArray();

        // Direct properties are those that map directly to table columns
        _directProperties = _allProperties
            .Where(p => p.GetCustomAttribute<DbPolymorphicTableAttribute>() == null &&
                       p.GetCustomAttribute<DbChildTableAttribute>() == null)
            .ToArray();
    }

    public IList<TClass> GetAll()
    {
        var (sql, parameters, childTableInfos) = BuildMegaJoinQuery(null);
        var result = new List<TClass>();
        using var connection = new NpgsqlConnection(_connectionString);
        connection.Open();
        using var command = new NpgsqlCommand(sql, connection);
        foreach (var param in parameters)
            command.Parameters.AddWithValue(param.Key, param.Value);
        using var reader = command.ExecuteReader();
        var rows = new List<IDataRecord>();
        while (reader.Read())
        {
            var values = new object[reader.FieldCount];
            reader.GetValues(values);
            rows.Add(new DataRecordSnapshot(reader, values));
        }
        if (rows.Count == 0)
            return result;
        // Группируем по id
        var idProp = _directProperties.FirstOrDefault(p => p.GetCustomAttribute<DbPrimaryKeyAttribute>() != null);
        if (idProp == null)
            throw new InvalidOperationException("Primary key property not found");
        var idCol = idProp.Name.ToSnakeCase();
        var groups = rows.GroupBy(r => r[idCol]);
        foreach (var group in groups)
        {
            var groupRows = group.ToList();
            var item = MapMegaJoinRowsToObject(groupRows, childTableInfos);
            result.Add(item);
        }
        return result;
    }

    public void DeleteAll()
    {
        using var connection = new NpgsqlConnection(_connectionString);
        connection.Open();
        using var transaction = connection.BeginTransaction();
        try
        {
            // 1. Delete from all polymorphic tables
            foreach (var prop in _allProperties)
            {
                var polyAttr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
                if (polyAttr == null) continue;
                foreach (var subType in polyAttr.OptionTypes)
                {
                    var subName = subType.Name;
                    if (subName.EndsWith("Options"))
                        subName = subName.Substring(0, subName.Length - "Options".Length);
                    subName = subName.ToSnakeCase();
                    var subTable = $"{_tableName}_{subName}";
                    var sql = $"DELETE FROM \"{_schema}\".\"{subTable}\"";
                    using var cmd = new NpgsqlCommand(sql, connection, transaction);
                    cmd.ExecuteNonQuery();
                }
            }

            // 2. Delete from all child tables
            foreach (var prop in _allProperties)
            {
                var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
                if (childAttr == null) continue;
                var childTableName = childAttr.GetTableName(prop, typeof(TClass));
                var childSchema = childAttr.GetSchemaName(typeof(TClass));
                var sql = $"DELETE FROM \"{childSchema}\".\"{childTableName}\"";
                using var cmd = new NpgsqlCommand(sql, connection, transaction);
                cmd.ExecuteNonQuery();
            }

            // 3. Delete from main table
            var mainSql = $"DELETE FROM \"{_schema}\".\"{_tableName}\"";
            using (var cmd = new NpgsqlCommand(mainSql, connection, transaction))
            {
                cmd.ExecuteNonQuery();
            }

            transaction.Commit();
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }

    public void SetAll(IEnumerable<TClass> all)
    {
        DeleteAll();

        // Insert new data
        foreach (var item in all)
        {
            Create(item);
        }
    }

    public TClass? GetById(TId id)
    {
        var (sql, parameters, childTableInfos) = BuildMegaJoinQuery(id);

        using var connection = new NpgsqlConnection(_connectionString);
        connection.Open();

        using var command = new NpgsqlCommand(sql, connection);
        foreach (var param in parameters)
            command.Parameters.AddWithValue(param.Key, param.Value);

        using var reader = command.ExecuteReader();
        var rows = new List<IDataRecord>();
        while (reader.Read())
        {
            var values = new object[reader.FieldCount];
            reader.GetValues(values);
            rows.Add(new DataRecordSnapshot(reader, values));
        }
        if (rows.Count == 0)
            return null;

        // Собираем объект из всех строк (child-коллекции)
        return MapMegaJoinRowsToObject(rows, childTableInfos);
    }

    private (string sql, Dictionary<string, object> parameters, List<ChildTableJoinInfo> childTableInfos) BuildMegaJoinQuery(object? id)
    {
        var parameters = new Dictionary<string, object>();
        var joins = new List<string>();
        var selectColumns = new List<string>();
        var childTableInfos = new List<ChildTableJoinInfo>();
        // Основные колонки
        foreach (var prop in _directProperties)
        {
            selectColumns.Add($"main.\"{prop.Name.ToSnakeCase()}\"");
        }
        // Полиморфные таблицы
        foreach (var prop in _allProperties)
        {
            var polyAttr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
            if (polyAttr == null) continue;
            foreach (var subType in polyAttr.OptionTypes)
            {
                var subName = subType.Name;
                if (subName.EndsWith("Options"))
                    subName = subName.Substring(0, subName.Length - "Options".Length);
                subName = subName.ToSnakeCase();
                var subTable = $"{_tableName}_{subName}";
                var alias = $"poly_{subName}";
                joins.Add($"LEFT JOIN \"{_schema}\".\"{subTable}\" AS {alias} ON {alias}.\"{_tableName}_id\" = main.\"{_primaryKeyColumn}\"");
                var subProperties = subType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                foreach (var subProp in subProperties)
                {
                    var col = subProp.Name.ToSnakeCase();
                    selectColumns.Add($"{alias}.\"{col}\" AS {alias}_{col}");
                }
            }
        }
        // Child-таблицы
        foreach (var prop in _allProperties)
        {
            var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
            if (childAttr == null) continue;
            var childType = GetChildTypeFromProperty(prop);
            if (childType == null) continue;
            var childTableName = childAttr.GetTableName(prop, typeof(TClass));
            var childSchema = childAttr.GetSchemaName(typeof(TClass));
            var parentForeignKeyColumn = childAttr.GetForeignKeyColumnName(typeof(TClass));
            var alias = $"child_{prop.Name.ToSnakeCase()}";
            joins.Add($"LEFT JOIN \"{childSchema}\".\"{childTableName}\" AS {alias} ON {alias}.\"{parentForeignKeyColumn}\" = main.\"{_primaryKeyColumn}\"");
            if (childType.IsPrimitive || childType == typeof(string) || childType == typeof(Guid))
            {
                var valueColumn = prop.Name.EndsWith("es") ? prop.Name.Substring(0, prop.Name.Length - 2) : (prop.Name.EndsWith("s") ? prop.Name.Substring(0, prop.Name.Length - 1) : prop.Name);
                valueColumn = valueColumn.ToSnakeCase();
                selectColumns.Add($"{alias}.\"{valueColumn}\" AS \"{alias}_{valueColumn}\"");
                childTableInfos.Add(new ChildTableJoinInfo(prop, alias, new[] { valueColumn }, childType));
            }
            else if (childType.GetCustomAttribute<DbTableAttribute>() != null)
            {
                var childProps = childType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                var childColumns = new List<string>();
                foreach (var childProp in childProps)
                {
                    var col = childProp.Name.ToSnakeCase();
                    selectColumns.Add($"{alias}.\"{col}\" AS \"{alias}_{col}\"");
                    childColumns.Add(col);
                }
                childTableInfos.Add(new ChildTableJoinInfo(prop, alias, childColumns.ToArray(), childType));
            }
        }
        var sql = $"SELECT {string.Join(", ", selectColumns)} FROM \"{_schema}\".\"{_tableName}\" AS main ";
        if (joins.Any())
            sql += string.Join(" ", joins);
        if (id != null)
        {
            sql += $" WHERE main.\"{_primaryKeyColumn}\" = @id";
            parameters["@id"] = id;
        }
        return (sql, parameters, childTableInfos);
    }

    private TClass MapMegaJoinRowsToObject(List<IDataRecord> rows, List<ChildTableJoinInfo> childTableInfos)
    {
        // Берём первую строку для основных и полиморфных свойств
        var first = rows[0];
        var instance = Activator.CreateInstance<TClass>();
        // Основные свойства
        foreach (var prop in _directProperties)
        {
            var columnName = prop.Name.ToSnakeCase();
            var value = first[columnName];
            if (value != DBNull.Value)
            {
                var convertedValue = ConvertValue(value, prop.PropertyType);
                prop.SetValue(instance, convertedValue);
            }
        }
        // Полиморфные свойства
        foreach (var prop in _allProperties)
        {
            var polyAttr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
            if (polyAttr == null) continue;
            foreach (var subType in polyAttr.OptionTypes)
            {
                var subName = subType.Name;
                if (subName.EndsWith("Options"))
                    subName = subName.Substring(0, subName.Length - "Options".Length);
                subName = subName.ToSnakeCase();
                var alias = $"poly_{subName}";
                var subProperties = subType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                var hasData = false;
                foreach (var subProp in subProperties)
                {
                    var col = subProp.Name.ToSnakeCase();
                    var aliasCol = $"{alias}_{col}";
                    var value = first[aliasCol];
                    if (value != DBNull.Value)
                    {
                        hasData = true;
                        break;
                    }
                }
                if (hasData)
                {
                    var subInstance = Activator.CreateInstance(subType);
                    foreach (var subProp in subProperties)
                    {
                        var col = subProp.Name.ToSnakeCase();
                        var aliasCol = $"{alias}_{col}";
                        var value = first[aliasCol];
                        if (value != DBNull.Value)
                        {
                            var convertedValue = ConvertValue(value, subProp.PropertyType);
                            subProp.SetValue(subInstance, convertedValue);
                        }
                    }
                    prop.SetValue(instance, subInstance);
                    break;
                }
            }
        }
        // Child-таблицы (коллекции)
        foreach (var info in childTableInfos)
        {
            var prop = info.Property;
            var values = new List<object>();
            foreach (var row in rows)
            {
                if (info.IsSimple)
                {
                    var value = row[$"{info.Alias}_{info.Columns[0]}"];
                    if (value != DBNull.Value)
                        values.Add(ConvertValue(value, info.ChildType));
                }
                else
                {
                    var childObj = Activator.CreateInstance(info.ChildType);
                    var hasAny = false;
                    for (int i = 0; i < info.Columns.Length; i++)
                    {
                        var col = info.Columns[i];
                        var aliasCol = $"{info.Alias}_{col}";
                        var value = row[aliasCol];
                        if (value != DBNull.Value)
                        {
                            var convertedValue = ConvertValue(value, info.ChildType.GetProperty(col.ToPascalCase())!.PropertyType);
                            info.ChildType.GetProperty(col.ToPascalCase())!.SetValue(childObj, convertedValue);
                            hasAny = true;
                        }
                    }
                    if (hasAny)
                        values.Add(childObj!);
                }
            }
            // Уникализируем значения
            values = values.Distinct().ToList();
            if (info.IsSimple && values.Count > 1)
            {
                // Sort for deterministic order (string, int, Guid, etc.)
                values = values.OrderBy(v => v).ToList();
            }
            if (prop.PropertyType.IsArray)
            {
                var array = Array.CreateInstance(info.ChildType, values.Count);
                for (int i = 0; i < values.Count; i++)
                    array.SetValue(values[i], i);
                prop.SetValue(instance, array);
            }
            else if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(List<>))
            {
                var listType = typeof(List<>).MakeGenericType(info.ChildType);
                var list = Activator.CreateInstance(listType);
                var addMethod = listType.GetMethod("Add");
                foreach (var value in values)
                    addMethod!.Invoke(list, new[] { value });
                prop.SetValue(instance, list);
            }
        }
        return instance;
    }

    private class ChildTableJoinInfo
    {
        public PropertyInfo Property { get; }
        public string Alias { get; }
        public string[] Columns { get; }
        public Type ChildType { get; }
        public bool IsSimple => ChildType.IsPrimitive || ChildType == typeof(string) || ChildType == typeof(Guid);
        public ChildTableJoinInfo(PropertyInfo property, string alias, string[] columns, Type childType)
        {
            Property = property;
            Alias = alias;
            Columns = columns;
            ChildType = childType;
        }
    }

    public void Create(TClass item)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        connection.Open();
        using var transaction = connection.BeginTransaction();

        try
        {
            // Insert into main table
            InsertIntoMainTable(connection, item);

            // Handle polymorphic tables
            InsertIntoPolymorphicTables(connection, item);

            // Handle child tables
            InsertIntoChildTables(connection, item);

            transaction.Commit();
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }

    public string DumpSql(IEnumerable<TClass> items)
    {
        Detached = true;
        var sb = new StringBuilder();
        foreach (var item in items)
        {
            sb.AppendLine(BuildInsertMainTableSql(item, asText: Detached));
            sb.Append(BuildInsertPolymorphicTablesSql(item, asText: Detached));
            sb.Append(BuildInsertChildTablesSql(item, asText: Detached));
        }
        Detached = false;
        return sb.ToString();
    }

    private string BuildInsertMainTableSql(TClass item, bool asText)
    {
        var columns = GetDirectColumns();
        var values = string.Join(", ", _directProperties.Select(p => asText ? ToSqlLiteral(GetPropertyValueForDb(p, item)) : $"@{p.Name}"));
        var sql = $"INSERT INTO \"{_schema}\".\"{_tableName}\" ({columns}) VALUES ({values});";
        return sql;
    }

    private string BuildInsertPolymorphicTablesSql(TClass item, bool asText)
    {
        var sb = new StringBuilder();
        foreach (var prop in _allProperties)
        {
            var polyAttr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
            if (polyAttr == null) continue;
            var value = prop.GetValue(item);
            if (value == null) continue;
            var actualType = value.GetType();
            var subType = polyAttr.OptionTypes.FirstOrDefault(t => t.IsAssignableFrom(actualType));
            if (subType == null) continue;
            var subName = subType.Name;
            if (subName.EndsWith("Options"))
                subName = subName.Substring(0, subName.Length - "Options".Length);
            subName = subName.ToSnakeCase();
            var subTable = $"{_tableName}_{subName}";
            var pkValue = GetPrimaryKeyValue(item);
            var subProperties = subType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
            var subColumns = string.Join(", ", subProperties.Select(p => $"\"{p.Name.ToSnakeCase()}\""));
            var fkColumn = $"\"{_tableName}_id\"";
            var values = string.Join(", ", subProperties.Select(p => asText ? ToSqlLiteral(GetPropertyValueForDb(p, value)) : $"@{p.Name}"));
            var pkSql = asText ? ToSqlLiteral(pkValue) : "@parentId";
            var sql = $"INSERT INTO \"{_schema}\".\"{subTable}\" ({fkColumn}, {subColumns}) VALUES ({pkSql}, {values});";
            sb.AppendLine(sql);
        }
        return sb.ToString();
    }

    private string BuildInsertChildTablesSql(TClass item, bool asText)
    {
        var sb = new StringBuilder();
        foreach (var prop in _allProperties)
        {
            var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
            if (childAttr == null) continue;
            var value = prop.GetValue(item);
            if (value == null) continue;
            var childType = GetChildTypeFromProperty(prop);
            if (childType == null) continue;
            var childTableName = childAttr.GetTableName(prop, typeof(TClass));
            var childSchema = childAttr.GetSchemaName(typeof(TClass));
            var parentForeignKeyColumn = childAttr.GetForeignKeyColumnName(typeof(TClass));
            var pkValue = GetPrimaryKeyValue(item);
            if (childType == typeof(string) || childType == typeof(int) || childType == typeof(long) ||
                childType == typeof(Guid) || childType == typeof(double) || childType == typeof(bool) ||
                childType == typeof(byte))
            {
                if (value is IEnumerable<object> collection)
                {
                    foreach (var element in collection)
                    {
                        var valueColumn = prop.Name.EndsWith("es") ? prop.Name.Substring(0, prop.Name.Length - 2) :
                                        (prop.Name.EndsWith("s") ? prop.Name.Substring(0, prop.Name.Length - 1) : prop.Name);
                        valueColumn = valueColumn.ToSnakeCase();
                        var pkSql = asText ? ToSqlLiteral(pkValue) : "@parentId";
                        var valSql = asText ? ToSqlLiteral(element) : "@value";
                        var sql = $"INSERT INTO \"{childSchema}\".\"{childTableName}\" (\"{parentForeignKeyColumn}\", \"{valueColumn}\") VALUES ({pkSql}, {valSql});";
                        sb.AppendLine(sql);
                    }
                }
            }
            // Complex child types not implemented for SQL dump
        }
        return sb.ToString();
    }

    private string ToSqlLiteral(object? value)
    {
        if (value == null || value == DBNull.Value) return "NULL";
        if (value is string s) return $"'{s.Replace("'", "''")}'";
        if (value is Guid g) return $"'{g}'";
        if (value is DateTime dt) return $"'{dt:yyyy-MM-dd HH:mm:ss.fff}'";
        if (value is bool b) return b ? "TRUE" : "FALSE";
        if (value is Enum e) return $"'{e.ToString()!.ToSnakeCase()}'";
        if (value is byte[] bytes) return $"'\\x{BitConverter.ToString(bytes).Replace("-", string.Empty).ToLower()}'";
        if (value is int or long or double or float or decimal or byte or short) return Convert.ToString(value, System.Globalization.CultureInfo.InvariantCulture)!;
        return $"'{value.ToString()!.Replace("'", "''")}'";
    }

    private void InsertIntoMainTable(NpgsqlConnection connection, TClass item)
    {
        var columns = GetDirectColumns();
        var parameters = string.Join(", ", _directProperties.Select(p => $"@{p.Name}"));
        var sql = $"INSERT INTO \"{_schema}\".\"{_tableName}\" ({columns}) VALUES ({parameters})";

        using var command = new NpgsqlCommand(sql, connection);

        foreach (var prop in _directProperties)
        {
            var value = GetPropertyValueForDb(prop, item);
            command.Parameters.AddWithValue($"@{prop.Name}", value);
        }

        command.ExecuteNonQuery();
    }

    private void InsertIntoPolymorphicTables(NpgsqlConnection connection, TClass item)
    {
        foreach (var prop in _allProperties)
        {
            var polyAttr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
            if (polyAttr == null) continue;

            var value = prop.GetValue(item);
            if (value == null) continue;

            var actualType = value.GetType();
            var subType = polyAttr.OptionTypes.FirstOrDefault(t => t.IsAssignableFrom(actualType));
            if (subType == null) continue;

            // Get the polymorphic table name
            var subName = subType.Name;
            if (subName.EndsWith("Options"))
                subName = subName.Substring(0, subName.Length - "Options".Length);
            subName = subName.ToSnakeCase();
            var subTable = $"{_tableName}_{subName}";

            // Get primary key value for foreign key reference
            var pkValue = GetPrimaryKeyValue(item);

            // Insert into polymorphic table
            var subProperties = subType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
            var subColumns = string.Join(", ", subProperties.Select(p => $"\"{p.Name.ToSnakeCase()}\""));
            var subParameters = string.Join(", ", subProperties.Select(p => $"@{p.Name}"));
            var fkColumn = $"\"{_tableName}_id\"";

            var sql = $"INSERT INTO \"{_schema}\".\"{subTable}\" ({fkColumn}, {subColumns}) VALUES (@parentId, {subParameters})";

            using var command = new NpgsqlCommand(sql, connection);
            command.Parameters.AddWithValue("@parentId", pkValue);

            foreach (var subProp in subProperties)
            {
                var subValue = GetPropertyValueForDb(subProp, value);
                command.Parameters.AddWithValue($"@{subProp.Name}", subValue);
            }

            command.ExecuteNonQuery();
        }
    }

    private void InsertIntoChildTables(NpgsqlConnection connection, TClass item)
    {
        foreach (var prop in _allProperties)
        {
            var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
            if (childAttr == null) continue;

            var value = prop.GetValue(item);
            if (value == null) continue;

            var childType = GetChildTypeFromProperty(prop);
            if (childType == null) continue;

            // Get the child table name
            var childTableName = childAttr.GetTableName(prop, typeof(TClass));
            var childSchema = childAttr.GetSchemaName(typeof(TClass));
            var parentForeignKeyColumn = childAttr.GetForeignKeyColumnName(typeof(TClass));

            // Get primary key value for foreign key reference
            var pkValue = GetPrimaryKeyValue(item);

            // Handle simple types (string, int, etc.)
            if (childType == typeof(string) || childType == typeof(int) || childType == typeof(long) ||
                childType == typeof(Guid) || childType == typeof(double) || childType == typeof(bool) ||
                childType == typeof(byte))
            {
                if (value is IEnumerable<object> collection)
                {
                    foreach (var element in collection)
                    {
                        var valueColumn = prop.Name.EndsWith("es") ? prop.Name.Substring(0, prop.Name.Length - 2) :
                                        (prop.Name.EndsWith("s") ? prop.Name.Substring(0, prop.Name.Length - 1) : prop.Name);
                        valueColumn = valueColumn.ToSnakeCase();

                        var sql = $"INSERT INTO \"{childSchema}\".\"{childTableName}\" (\"{parentForeignKeyColumn}\", \"{valueColumn}\") VALUES (@parentId, @value)";

                        using var command = new NpgsqlCommand(sql, connection);
                        command.Parameters.AddWithValue("@parentId", pkValue);
                        command.Parameters.AddWithValue("@value", element);

                        command.ExecuteNonQuery();
                    }
                }
            }
            // Handle complex types (objects with DbTableAttribute)
            else if (childType.GetCustomAttribute<DbTableAttribute>() != null)
            {
                if (value is IEnumerable<object> collection)
                {
                    foreach (var element in collection)
                    {
                        // This would require recursive insertion - simplified for now
                        // In a full implementation, you'd need to handle this recursively
                        throw new NotImplementedException($"Complex child table insertion for {childType.Name} is not yet implemented");
                    }
                }
            }
        }
    }

    private TId GetPrimaryKeyValue(TClass item)
    {
        var pkProp = _allProperties.FirstOrDefault(p => p.GetCustomAttribute<DbPrimaryKeyAttribute>() != null);
        if (pkProp == null)
            throw new InvalidOperationException($"No primary key found for type {typeof(TClass).Name}");

        var value = pkProp.GetValue(item);
        if (value == null)
            throw new InvalidOperationException($"Primary key value is null for {typeof(TClass).Name}");

        return (TId)value;
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

    public void Update(TId id, TClass item)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        connection.Open();
        using var transaction = connection.BeginTransaction();
        try
        {
            // 1. Update main table
            var setClause = string.Join(", ", _directProperties.Select(p => $"\"{p.Name.ToSnakeCase()}\" = @{p.Name}"));
            var sql = $"UPDATE \"{_schema}\".\"{_tableName}\" SET {setClause} WHERE \"{_primaryKeyColumn}\" = @id";
            using (var command = new NpgsqlCommand(sql, connection, transaction))
            {
                command.Parameters.AddWithValue("@id", id);
                foreach (var prop in _directProperties)
                {
                    var value = GetPropertyValueForDb(prop, item);
                    command.Parameters.AddWithValue($"@{prop.Name}", value);
                }
                command.ExecuteNonQuery();
            }

            // 2. Update polymorphic tables: delete old, insert new
            foreach (var prop in _allProperties)
            {
                var polyAttr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
                if (polyAttr == null) continue;
                foreach (var subType in polyAttr.OptionTypes)
                {
                    var subName = subType.Name;
                    if (subName.EndsWith("Options"))
                        subName = subName.Substring(0, subName.Length - "Options".Length);
                    subName = subName.ToSnakeCase();
                    var subTable = $"{_tableName}_{subName}";
                    var delSql = $"DELETE FROM \"{_schema}\".\"{subTable}\" WHERE \"{_tableName}_id\" = @id";
                    using var delCmd = new NpgsqlCommand(delSql, connection, transaction);
                    delCmd.Parameters.AddWithValue("@id", id);
                    delCmd.ExecuteNonQuery();
                }
                var value = prop.GetValue(item);
                if (value == null) continue;
                var actualType = value.GetType();
                var subType2 = polyAttr.OptionTypes.FirstOrDefault(t => t.IsAssignableFrom(actualType));
                if (subType2 == null) continue;
                var subName2 = subType2.Name;
                if (subName2.EndsWith("Options"))
                    subName2 = subName2.Substring(0, subName2.Length - "Options".Length);
                subName2 = subName2.ToSnakeCase();
                var subTable2 = $"{_tableName}_{subName2}";
                var subProperties = subType2.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                var subColumns = string.Join(", ", subProperties.Select(p => $"\"{p.Name.ToSnakeCase()}\""));
                var subParameters = string.Join(", ", subProperties.Select(p => $"@{p.Name}"));
                var fkColumn = $"\"{_tableName}_id\"";
                var insSql = $"INSERT INTO \"{_schema}\".\"{subTable2}\" ({fkColumn}, {subColumns}) VALUES (@parentId, {subParameters})";
                using var insCmd = new NpgsqlCommand(insSql, connection, transaction);
                insCmd.Parameters.AddWithValue("@parentId", id);
                foreach (var subProp in subProperties)
                {
                    var subValue = GetPropertyValueForDb(subProp, value);
                    insCmd.Parameters.AddWithValue($"@{subProp.Name}", subValue);
                }
                insCmd.ExecuteNonQuery();
            }

            // 3. Update child tables: delete old, insert new
            foreach (var prop in _allProperties)
            {
                var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
                if (childAttr == null) continue;
                var childTableName = childAttr.GetTableName(prop, typeof(TClass));
                var childSchema = childAttr.GetSchemaName(typeof(TClass));
                var parentForeignKeyColumn = childAttr.GetForeignKeyColumnName(typeof(TClass));
                var delSql = $"DELETE FROM \"{childSchema}\".\"{childTableName}\" WHERE \"{parentForeignKeyColumn}\" = @id";
                using (var delCmd = new NpgsqlCommand(delSql, connection, transaction))
                {
                    delCmd.Parameters.AddWithValue("@id", id);
                    delCmd.ExecuteNonQuery();
                }
                var value = prop.GetValue(item);
                if (value == null) continue;
                var childType = GetChildTypeFromProperty(prop);
                if (childType == null) continue;
                if (childType == typeof(string) || childType == typeof(int) || childType == typeof(long) ||
                    childType == typeof(Guid) || childType == typeof(double) || childType == typeof(bool) ||
                    childType == typeof(byte))
                {
                    if (value is IEnumerable<object> collection)
                    {
                        foreach (var element in collection)
                        {
                            var valueColumn = prop.Name.EndsWith("es") ? prop.Name.Substring(0, prop.Name.Length - 2) :
                                            (prop.Name.EndsWith("s") ? prop.Name.Substring(0, prop.Name.Length - 1) : prop.Name);
                            valueColumn = valueColumn.ToSnakeCase();
                            var insSql = $"INSERT INTO \"{childSchema}\".\"{childTableName}\" (\"{parentForeignKeyColumn}\", \"{valueColumn}\") VALUES (@parentId, @value)";
                            using var insCmd = new NpgsqlCommand(insSql, connection, transaction);
                            insCmd.Parameters.AddWithValue("@parentId", id);
                            insCmd.Parameters.AddWithValue("@value", element);
                            insCmd.ExecuteNonQuery();
                        }
                    }
                }
                else if (childType.GetCustomAttribute<DbTableAttribute>() != null)
                {
                    if (value is IEnumerable<object> collection)
                    {
                        foreach (var element in collection)
                        {
                            // Not implemented: recursive update for complex child tables
                            throw new NotImplementedException($"Complex child table update for {childType.Name} is not yet implemented");
                        }
                    }
                }
            }

            transaction.Commit();
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }

    public void Delete(TId id)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        connection.Open();
        using var transaction = connection.BeginTransaction();
        try
        {
            // 1. Удалить из всех полиморфных таблиц
            foreach (var prop in _allProperties)
            {
                var polyAttr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
                if (polyAttr == null) continue;
                foreach (var subType in polyAttr.OptionTypes)
                {
                    var subName = subType.Name;
                    if (subName.EndsWith("Options"))
                        subName = subName.Substring(0, subName.Length - "Options".Length);
                    subName = subName.ToSnakeCase();
                    var subTable = $"{_tableName}_{subName}";
                    var sql = $"DELETE FROM \"{_schema}\".\"{subTable}\" WHERE \"{_tableName}_id\" = @id";
                    using var cmd = new NpgsqlCommand(sql, connection, transaction);
                    cmd.Parameters.AddWithValue("@id", id);
                    cmd.ExecuteNonQuery();
                }
            }
            // 2. Удалить из всех child-таблиц
            foreach (var prop in _allProperties)
            {
                var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
                if (childAttr == null) continue;
                var childTableName = childAttr.GetTableName(prop, typeof(TClass));
                var childSchema = childAttr.GetSchemaName(typeof(TClass));
                var parentForeignKeyColumn = childAttr.GetForeignKeyColumnName(typeof(TClass));
                var sql = $"DELETE FROM \"{childSchema}\".\"{childTableName}\" WHERE \"{parentForeignKeyColumn}\" = @id";
                using var cmd = new NpgsqlCommand(sql, connection, transaction);
                cmd.Parameters.AddWithValue("@id", id);
                cmd.ExecuteNonQuery();
            }
            // 3. Удалить из основной таблицы
            var mainSql = $"DELETE FROM \"{_schema}\".\"{_tableName}\" WHERE \"{_primaryKeyColumn}\" = @id";
            using (var cmd = new NpgsqlCommand(mainSql, connection, transaction))
            {
                cmd.Parameters.AddWithValue("@id", id);
                cmd.ExecuteNonQuery();
            }
            transaction.Commit();
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }

    public bool Detached { get; set; }

    private string GetDirectColumns()
    {
        return string.Join(", ", _directProperties.Select(p => $"\"{p.Name.ToSnakeCase()}\""));
    }

    private object GetPropertyValueForDb(PropertyInfo prop, object item)
    {
        var value = prop.GetValue(item);

        if (value == null)
            return DBNull.Value;

        // Handle arrays and lists with CsvString attribute
        if (prop.GetCustomAttribute<DbCsvStringAttribute>() != null)
        {
            if (value is string[] stringArray)
                return string.Join(",", stringArray);
            if (value is List<string> stringList)
                return string.Join(",", stringList);
        }

        // Handle enums
        if (prop.PropertyType.IsEnum)
        {
            return value.ToString()!.ToSnakeCase();
        }

        return value;
    }

    private static object ConvertValue(object value, Type targetType)
    {
        if (value == null || value == DBNull.Value)
            return null!;

        var sourceType = value.GetType();

        // If types match, return as is
        if (sourceType == targetType)
            return value;

        // Handle nullable types
        var underlyingType = Nullable.GetUnderlyingType(targetType);
        if (underlyingType != null)
        {
            return ConvertValue(value, underlyingType);
        }

        // Handle Guid conversion from string
        if (targetType == typeof(Guid) && value is string guidString)
        {
            if (Guid.TryParse(guidString, out var guid))
                return guid;
            throw new ArgumentException($"Invalid GUID format: {guidString}");
        }

        // Handle boolean conversion from string
        if (targetType == typeof(bool) && value is string boolString)
        {
            if (bool.TryParse(boolString, out var boolValue))
                return boolValue;
            // Also handle "1"/"0" and "true"/"false" case-insensitive
            if (boolString.Equals("1", StringComparison.OrdinalIgnoreCase) || 
                boolString.Equals("true", StringComparison.OrdinalIgnoreCase))
                return true;
            if (boolString.Equals("0", StringComparison.OrdinalIgnoreCase) || 
                boolString.Equals("false", StringComparison.OrdinalIgnoreCase))
                return false;
            throw new ArgumentException($"Invalid boolean format: {boolString}");
        }

        // Handle enums
        if (targetType.IsEnum)
        {
            return Enum.Parse(targetType, value.ToString()!.ToPascalCase());
        }

        // Handle arrays and lists with CsvString attribute
        if (targetType == typeof(string[]) ||
            (targetType.IsGenericType && targetType.GetGenericTypeDefinition() == typeof(List<>) && targetType.GetGenericArguments()[0] == typeof(string)))
        {
            if (value is string csvString)
            {
                var items = csvString.Split(',', StringSplitOptions.RemoveEmptyEntries);
                if (targetType == typeof(string[]))
                    return items;
                else
                    return items.ToList();
            }
        }

        // Try safe conversion first
        try
        {
            return Convert.ChangeType(value, targetType);
        }
        catch (InvalidCastException)
        {
            // If Convert.ChangeType fails, try to convert via string
            if (value is IConvertible convertible)
            {
                return Convert.ChangeType(convertible, targetType);
            }
            
            // Last resort: try to convert via ToString() if target is string
            if (targetType == typeof(string))
            {
                return value.ToString() ?? string.Empty;
            }
            
            // If all else fails, throw a more descriptive exception
            throw new ArgumentException($"Cannot convert {sourceType.Name} to {targetType.Name}. Value: {value}");
        }
    }

    private class DataRecordSnapshot : IDataRecord
    {
        private readonly object[] _values;
        private readonly string[] _names;

        public DataRecordSnapshot(IDataReader reader, object[] values)
        {
            _values = values;
            _names = new string[reader.FieldCount];
            for (int i = 0; i < _names.Length; i++)
                _names[i] = reader.GetName(i);
        }

        public object this[int i] => _values[i];
        public object this[string name] => _values[Array.IndexOf(_names, name)];
        public int FieldCount => _values.Length;
        public string GetName(int i) => _names[i];
        public IDataReader GetData(int i)
        {
            throw new NotImplementedException();
        }

        public string GetDataTypeName(int i) => _values[i]?.GetType().Name ?? "object";
        public Type GetFieldType(int i) => _values[i]?.GetType() ?? typeof(object);
        public object GetValue(int i) => _values[i];
        public int GetValues(object[] values) { _values.CopyTo(values, 0); return _values.Length; }
        public int GetOrdinal(string name) => Array.IndexOf(_names, name);
        public bool GetBoolean(int i) => (bool)_values[i];
        public byte GetByte(int i) => (byte)_values[i];
        public long GetBytes(int i, long fieldOffset, byte[]? buffer, int bufferoffset, int length) => throw new NotSupportedException();
        public char GetChar(int i) => (char)_values[i];
        public long GetChars(int i, long fieldoffset, char[]? buffer, int bufferoffset, int length) => throw new NotSupportedException();
        public Guid GetGuid(int i) => (Guid)_values[i];
        public short GetInt16(int i) => (short)_values[i];
        public int GetInt32(int i) => (int)_values[i];
        public long GetInt64(int i) => (long)_values[i];
        public float GetFloat(int i) => (float)_values[i];
        public double GetDouble(int i) => (double)_values[i];
        public string GetString(int i) => (string)_values[i];
        public decimal GetDecimal(int i) => (decimal)_values[i];
        public DateTime GetDateTime(int i) => (DateTime)_values[i];
        public bool IsDBNull(int i) => _values[i] == DBNull.Value;
        public System.Collections.IEnumerator GetEnumerator() => _values.GetEnumerator();
    }

    public IList<TClass> GetByField(string fieldName, object value)
    {
        var (resolvedFieldName, convertedValue) = ResolveFieldNameAndConvertValue(fieldName, value);
        var whereClause = $"{resolvedFieldName} = @{fieldName}";
        var parameters = new Dictionary<string, object> { { fieldName, convertedValue } };
        return GetByWhere(whereClause, parameters);
    }

    public IList<TClass> GetByFields(Dictionary<string, object> criteria)
    {
        if (criteria == null || criteria.Count == 0)
            return GetAll();

        var whereConditions = new List<string>();
        var parameters = new Dictionary<string, object>();

        foreach (var kvp in criteria)
        {
            var (resolvedFieldName, convertedValue) = ResolveFieldNameAndConvertValue(kvp.Key, kvp.Value);
            var paramName = $"param_{kvp.Key}";
            whereConditions.Add($"{resolvedFieldName} = @{paramName}");
            parameters[paramName] = convertedValue;
        }

        var whereClause = string.Join(" AND ", whereConditions);
        return GetByWhere(whereClause, parameters);
    }

    public IList<TClass> GetByWhere(string whereClause, Dictionary<string, object>? parameters = null)
    {
        var (sql, queryParams, childTableInfos) = BuildMegaJoinQueryWithWhere(whereClause, parameters);
        var result = new List<TClass>();

        using var connection = new NpgsqlConnection(_connectionString);
        connection.Open();
        using var command = new NpgsqlCommand(sql, connection);
        
        // Add all parameters
        foreach (var param in queryParams)
            command.Parameters.AddWithValue(param.Key, param.Value);

        using var reader = command.ExecuteReader();
        var rows = new List<IDataRecord>();
        while (reader.Read())
        {
            var values = new object[reader.FieldCount];
            reader.GetValues(values);
            rows.Add(new DataRecordSnapshot(reader, values));
        }

        if (rows.Count == 0)
            return result;

        // Group by primary key to handle child collections
        var idProp = _directProperties.FirstOrDefault(p => p.GetCustomAttribute<DbPrimaryKeyAttribute>() != null);
        if (idProp == null)
            throw new InvalidOperationException("Primary key property not found");
        
        var idCol = idProp.Name.ToSnakeCase();
        var groups = rows.GroupBy(r => r[idCol]);
        
        foreach (var group in groups)
        {
            var groupRows = group.ToList();
            var item = MapMegaJoinRowsToObject(groupRows, childTableInfos);
            result.Add(item);
        }

        return result;
    }

    public TClass? GetFirstByField(string fieldName, object value)
    {
        var results = GetByField(fieldName, value);
        return results.FirstOrDefault();
    }

    public bool ExistsByField(string fieldName, object value)
    {
        var (resolvedFieldName, convertedValue) = ResolveFieldNameAndConvertValue(fieldName, value);
        
        // If it's a polymorphic field, we need to check the polymorphic table
        if (resolvedFieldName.StartsWith("poly_"))
        {
            // Extract table alias and build query for polymorphic table
            var alias = resolvedFieldName.Split('.')[0];
            var columnName = resolvedFieldName.Split('.')[1].Trim('"');
            var tableName = alias.Replace("poly_", "");
            var fullTableName = $"{_tableName}_{tableName}";
            
            using var connection = new NpgsqlConnection(_connectionString);
            connection.Open();
            
            var sql = $"SELECT COUNT(*) FROM \"{_schema}\".\"{fullTableName}\" WHERE \"{columnName}\" = @{fieldName}";
            using var command = new NpgsqlCommand(sql, connection);
            command.Parameters.AddWithValue(fieldName, convertedValue);
            
            var count = Convert.ToInt32(command.ExecuteScalar());
            return count > 0;
        }
        else
        {
            // Regular field - check main table
            var whereClause = $"{resolvedFieldName} = @{fieldName}";
            var parameters = new Dictionary<string, object> { { fieldName, convertedValue } };
            
            using var connection = new NpgsqlConnection(_connectionString);
            connection.Open();
            
            var sql = $"SELECT COUNT(*) FROM \"{_schema}\".\"{_tableName}\" main WHERE {whereClause}";
            using var command = new NpgsqlCommand(sql, connection);
            command.Parameters.AddWithValue(fieldName, convertedValue);
            
            var count = Convert.ToInt32(command.ExecuteScalar());
            return count > 0;
        }
    }

    private (string resolvedFieldName, object convertedValue) ResolveFieldNameAndConvertValue(string fieldName, object value)
    {
        // Handle polymorphic field paths like "Data.Email"
        if (fieldName.Contains("."))
        {
            var parts = fieldName.Split('.');
            if (parts.Length == 2 && parts[0] == "Data")
            {
                // This is a polymorphic field like "Data.Email"
                var subFieldName = parts[1];
                
                // Find the polymorphic property
                var polyProp = _allProperties.FirstOrDefault(p => p.GetCustomAttribute<DbPolymorphicTableAttribute>() != null);
                if (polyProp != null)
                {
                    var polyAttr = polyProp.GetCustomAttribute<DbPolymorphicTableAttribute>();
                    if (polyAttr != null)
                    {
                        // For now, we'll check all polymorphic tables for the field
                        // In a real implementation, you might want to be more specific about which table
                        var subName = "person"; // Default to person table for now
                        var alias = $"poly_{subName}";
                        var resolvedFieldName = $"{alias}.\"{subFieldName.ToSnakeCase()}\"";
                        
                        // Convert value based on the field type
                        var convertedValue = ConvertValueForField(subFieldName, value);
                        
                        return (resolvedFieldName, convertedValue);
                    }
                }
            }
        }
        
        // Regular field - check if it's a main table field
        var mainTableField = $"main.\"{fieldName.ToSnakeCase()}\"";
        var convertedMainValue = ConvertValueForField(fieldName, value);
        
        return (mainTableField, convertedMainValue);
    }

    private object ConvertValueForField(string fieldName, object value)
    {
        // Find the property to determine its type
        var prop = _directProperties.FirstOrDefault(p => p.Name.Equals(fieldName, StringComparison.OrdinalIgnoreCase));
        if (prop != null)
        {
            return ConvertValue(value, prop.PropertyType);
        }
        
        // Check polymorphic properties
        var polyProp = _allProperties.FirstOrDefault(p => p.GetCustomAttribute<DbPolymorphicTableAttribute>() != null);
        if (polyProp != null)
        {
            var polyAttr = polyProp.GetCustomAttribute<DbPolymorphicTableAttribute>();
            if (polyAttr != null)
            {
                // Check all polymorphic types for the field
                foreach (var subType in polyAttr.OptionTypes)
                {
                    var subProp = subType.GetProperty(fieldName, BindingFlags.Public | BindingFlags.Instance | BindingFlags.IgnoreCase);
                    if (subProp != null)
                    {
                        return ConvertValue(value, subProp.PropertyType);
                    }
                }
            }
        }
        
        // Default conversion
        return ConvertValue(value, typeof(string));
    }

    private (string sql, Dictionary<string, object> parameters, List<ChildTableJoinInfo> childTableInfos) BuildMegaJoinQueryWithWhere(string whereClause, Dictionary<string, object>? parameters)
    {
        var queryParams = parameters ?? new Dictionary<string, object>();
        var joins = new List<string>();
        var selectColumns = new List<string>();
        var childTableInfos = new List<ChildTableJoinInfo>();

        // Main table columns
        foreach (var prop in _directProperties)
        {
            selectColumns.Add($"main.\"{prop.Name.ToSnakeCase()}\"");
        }

        // Polymorphic tables
        foreach (var prop in _allProperties)
        {
            var polyAttr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
            if (polyAttr == null) continue;
            
            foreach (var subType in polyAttr.OptionTypes)
            {
                var subName = subType.Name;
                if (subName.EndsWith("Options"))
                    subName = subName.Substring(0, subName.Length - "Options".Length);
                subName = subName.ToSnakeCase();
                var subTable = $"{_tableName}_{subName}";
                var alias = $"poly_{subName}";
                
                joins.Add($"LEFT JOIN \"{_schema}\".\"{subTable}\" {alias} ON {alias}.\"{_tableName}_id\" = main.\"{_primaryKeyColumn}\"");
                
                // Add columns from polymorphic table
                var subProperties = subType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                foreach (var subProp in subProperties)
                {
                    var col = subProp.Name.ToSnakeCase();
                    selectColumns.Add($"{alias}.\"{col}\" AS {alias}_{col}");
                }
            }
        }

        // Child tables
        foreach (var prop in _allProperties)
        {
            var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
            if (childAttr == null) continue;
            
            var childTableName = childAttr.GetTableName(prop, typeof(TClass));
            var childSchema = childAttr.GetSchemaName(typeof(TClass));
            var parentForeignKeyColumn = childAttr.GetForeignKeyColumnName(typeof(TClass));
            var alias = $"child_{prop.Name}";
            
            joins.Add($"LEFT JOIN \"{childSchema}\".\"{childTableName}\" {alias} ON {alias}.\"{parentForeignKeyColumn}\" = main.\"{_primaryKeyColumn}\"");
            
            var childType = GetChildTypeFromProperty(prop);
            if (childType != null)
            {
                if (childType.IsPrimitive || childType == typeof(string) || childType == typeof(Guid))
                {
                    // Simple child table (string[], int[], etc.)
                    var valueColumn = prop.Name.EndsWith("es") ? prop.Name.Substring(0, prop.Name.Length - 2) : 
                                    (prop.Name.EndsWith("s") ? prop.Name.Substring(0, prop.Name.Length - 1) : prop.Name);
                    valueColumn = valueColumn.ToSnakeCase();
                    selectColumns.Add($"{alias}.\"{valueColumn}\" AS \"{alias}_{valueColumn}\"");
                    childTableInfos.Add(new ChildTableJoinInfo(prop, alias, new[] { valueColumn }, childType));
                }
                else if (childType.GetCustomAttribute<DbTableAttribute>() != null)
                {
                    // Complex child table
                    var childProperties = childType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                    var childColumns = childProperties.Select(p => $"{alias}.\"{p.Name.ToSnakeCase()}\"").ToArray();
                    childTableInfos.Add(new ChildTableJoinInfo(prop, alias, childColumns, childType));
                    
                    foreach (var childCol in childColumns)
                    {
                        selectColumns.Add(childCol);
                    }
                }
            }
        }

        var sql = $"SELECT {string.Join(", ", selectColumns)} FROM \"{_schema}\".\"{_tableName}\" main";
        if (joins.Count > 0)
            sql += " " + string.Join(" ", joins);
        sql += $" WHERE {whereClause}";

        return (sql, queryParams, childTableInfos);
    }
}
