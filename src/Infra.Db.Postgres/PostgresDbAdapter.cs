using System.Reflection;
using Npgsql;
using System.Data;
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

    public IEnumerable<TClass> GetAll()
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
                    var columnName = subProp.Name.ToSnakeCase();
                    selectColumns.Add($"{alias}.\"{columnName}\" AS \"{alias}_{columnName}\"");
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
        var setClause = string.Join(", ", _directProperties.Select(p => $"\"{p.Name.ToSnakeCase()}\" = @{p.Name}"));
        var sql = $"UPDATE \"{_schema}\".\"{_tableName}\" SET {setClause} WHERE \"{_primaryKeyColumn}\" = @id";

        using var connection = new NpgsqlConnection(_connectionString);
        connection.Open();

        using var command = new NpgsqlCommand(sql, connection);
        command.Parameters.AddWithValue("@id", id);

        foreach (var prop in _directProperties)
        {
            var value = GetPropertyValueForDb(prop, item);
            command.Parameters.AddWithValue($"@{prop.Name}", value);
        }

        command.ExecuteNonQuery();
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

    private string GetDirectColumns()
    {
        return string.Join(", ", _directProperties.Select(p => $"\"{p.Name.ToSnakeCase()}\""));
    }

    private TClass MapReaderToObject(IDataReader reader)
    {
        var instance = Activator.CreateInstance<TClass>();

        foreach (var prop in _directProperties)
        {
            var columnName = prop.Name.ToSnakeCase();
            var value = reader[columnName];

            if (value != DBNull.Value)
            {
                var convertedValue = ConvertValue(value, prop.PropertyType);
                prop.SetValue(instance, convertedValue);
            }
        }

        return instance;
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
            return Convert.ChangeType(value, underlyingType);
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

        // Default conversion
        return Convert.ChangeType(value, targetType);
    }

    private void LoadPolymorphicData(NpgsqlConnection connection, TClass item)
    {
        foreach (var prop in _allProperties)
        {
            var polyAttr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
            if (polyAttr == null) continue;

            var pkValue = GetPrimaryKeyValue(item);

            // Try to load from each possible polymorphic table
            foreach (var subType in polyAttr.OptionTypes)
            {
                var subName = subType.Name;
                if (subName.EndsWith("Options"))
                    subName = subName.Substring(0, subName.Length - "Options".Length);
                subName = subName.ToSnakeCase();
                var subTable = $"{_tableName}_{subName}";

                var subProperties = subType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                var subColumns = string.Join(", ", subProperties.Select(p => $"\"{p.Name.ToSnakeCase()}\""));
                var sql = $"SELECT {subColumns} FROM \"{_schema}\".\"{subTable}\" WHERE \"{_tableName}_id\" = @parentId";

                using var command = new NpgsqlCommand(sql, connection);
                command.Parameters.AddWithValue("@parentId", pkValue);

                using var reader = command.ExecuteReader();
                if (reader.Read())
                {
                    // Found data in this polymorphic table
                    var subInstance = Activator.CreateInstance(subType);

                    foreach (var subProp in subProperties)
                    {
                        var columnName = subProp.Name.ToSnakeCase();
                        var value = reader[columnName];

                        if (value != DBNull.Value)
                        {
                            var convertedValue = ConvertValue(value, subProp.PropertyType);
                            subProp.SetValue(subInstance, convertedValue);
                        }
                    }

                    prop.SetValue(item, subInstance);
                    break; // Found the correct polymorphic table
                }
            }
        }
    }

    private void LoadChildData(NpgsqlConnection connection, TClass item)
    {
        foreach (var prop in _allProperties)
        {
            var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
            if (childAttr == null) continue;

            var pkValue = GetPrimaryKeyValue(item);
            var childType = GetChildTypeFromProperty(prop);
            if (childType == null) continue;

            var childTableName = childAttr.GetTableName(prop, typeof(TClass));
            var childSchema = childAttr.GetSchemaName(typeof(TClass));
            var parentForeignKeyColumn = childAttr.GetForeignKeyColumnName(typeof(TClass));

            // Handle simple types
            if (childType == typeof(string) || childType == typeof(int) || childType == typeof(long) ||
                childType == typeof(Guid) || childType == typeof(double) || childType == typeof(bool) ||
                childType == typeof(byte))
            {
                var valueColumn = prop.Name.EndsWith("es") ? prop.Name.Substring(0, prop.Name.Length - 2) :
                                (prop.Name.EndsWith("s") ? prop.Name.Substring(0, prop.Name.Length - 1) : prop.Name);
                valueColumn = valueColumn.ToSnakeCase();

                var sql = $"SELECT \"{valueColumn}\" FROM \"{childSchema}\".\"{childTableName}\" WHERE \"{parentForeignKeyColumn}\" = @parentId ORDER BY \"{valueColumn}\"";

                using var command = new NpgsqlCommand(sql, connection);
                command.Parameters.AddWithValue("@parentId", pkValue);

                using var reader = command.ExecuteReader();
                var values = new List<object>();

                while (reader.Read())
                {
                    var value = reader[valueColumn];
                    if (value != DBNull.Value)
                    {
                        values.Add(value);
                    }
                }

                // Create the appropriate collection type
                if (prop.PropertyType.IsArray)
                {
                    var array = Array.CreateInstance(childType, values.Count);
                    for (int i = 0; i < values.Count; i++)
                    {
                        array.SetValue(Convert.ChangeType(values[i], childType), i);
                    }
                    prop.SetValue(item, array);
                }
                else if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(List<>))
                {
                    var listType = typeof(List<>).MakeGenericType(childType);
                    var list = Activator.CreateInstance(listType);
                    var addMethod = listType.GetMethod("Add");

                    foreach (var value in values)
                    {
                        addMethod!.Invoke(list, new[] { Convert.ChangeType(value, childType) });
                    }

                    prop.SetValue(item, list);
                }
            }
            // Handle complex types (simplified - would need recursive loading in full implementation)
            else if (childType.GetCustomAttribute<DbTableAttribute>() != null)
            {
                // For now, just log that complex child tables are not fully implemented
                // In a full implementation, you'd need to recursively load these objects
                Console.WriteLine($"Complex child table loading for {childType.Name} is not yet fully implemented");
            }
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
}
