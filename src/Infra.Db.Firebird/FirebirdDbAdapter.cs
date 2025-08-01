using System.Reflection;
using FirebirdSql.Data.FirebirdClient;
using System.Data;
using System.Text;
using Infra.Db.Attributes;

namespace Infra.Db;

public class FirebirdDbAdapter<TClass, TId> : IDbAdapter<TClass, TId>
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

    public FirebirdDbAdapter(string connectionString)
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
        using var connection = new FbConnection(_connectionString);
        connection.Open();
        using var command = new FbCommand(sql, connection);
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
        // Group by id
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
        using var connection = new FbConnection(_connectionString);
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
                    var sql = $"DELETE FROM {subTable}";
                    using var command = new FbCommand(sql, connection, transaction);
                    command.ExecuteNonQuery();
                }
            }

            // 2. Delete from all child tables
            foreach (var prop in _allProperties)
            {
                var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
                if (childAttr == null) continue;
                var childTableName = childAttr.GetTableName(prop, typeof(TClass));
                var sql = $"DELETE FROM {childTableName}";
                using var command = new FbCommand(sql, connection, transaction);
                command.ExecuteNonQuery();
            }

            // 3. Delete from main table
            var mainTableSql = $"DELETE FROM {_tableName}";
            using var mainCommand = new FbCommand(mainTableSql, connection, transaction);
            mainCommand.ExecuteNonQuery();

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
        foreach (var item in all)
        {
            Create(item);
        }
    }

    public TClass? GetById(TId id)
    {
        var (sql, parameters, childTableInfos) = BuildMegaJoinQuery(id);
        using var connection = new FbConnection(_connectionString);
        connection.Open();
        using var command = new FbCommand(sql, connection);
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
        return MapMegaJoinRowsToObject(rows, childTableInfos);
    }

    private (string sql, Dictionary<string, object> parameters, List<ChildTableJoinInfo> childTableInfos) BuildMegaJoinQuery(object? id)
    {
        var parameters = new Dictionary<string, object>();
        var childTableInfos = new List<ChildTableJoinInfo>();

        // Start with main table
        var sql = $"SELECT * FROM {_tableName}";
        var aliasCounter = 1;

        // Add polymorphic table joins
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
                var alias = $"pt{aliasCounter++}";
                sql += $" LEFT JOIN {subTable} {alias} ON {_tableName}.{_primaryKeyColumn} = {alias}.{_primaryKeyColumn}";
            }
        }

        // Add child table joins
        foreach (var prop in _allProperties)
        {
            var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
            if (childAttr == null) continue;
            var childTableName = childAttr.GetTableName(prop, typeof(TClass));
            var alias = $"ct{aliasCounter++}";
            sql += $" LEFT JOIN {childTableName} {alias} ON {_tableName}.{_primaryKeyColumn} = {alias}.{_primaryKeyColumn}";
            
            var childType = GetChildTypeFromProperty(prop);
            if (childType != null)
            {
                var columns = GetChildTableColumns(prop, childType);
                childTableInfos.Add(new ChildTableJoinInfo(prop, alias, columns, childType));
            }
        }

        // Add WHERE clause if id is provided
        if (id != null)
        {
            sql += $" WHERE {_tableName}.{_primaryKeyColumn} = @id";
            parameters["@id"] = id;
        }

        return (sql, parameters, childTableInfos);
    }

    private TClass MapMegaJoinRowsToObject(List<IDataRecord> rows, List<ChildTableJoinInfo> childTableInfos)
    {
        var result = Activator.CreateInstance<TClass>();
        var firstRow = rows.First();

        // Map direct properties from main table
        foreach (var prop in _directProperties)
        {
            var columnName = prop.Name.ToSnakeCase();
            var value = firstRow[columnName];
            if (value != DBNull.Value)
            {
                prop.SetValue(result, ConvertValue(value, prop.PropertyType));
            }
        }

        // Map polymorphic table properties
        foreach (var prop in _allProperties)
        {
            var polyAttr = prop.GetCustomAttribute<DbPolymorphicTableAttribute>();
            if (polyAttr == null) continue;
            
            var actualType = prop.GetValue(result)?.GetType();
            if (actualType == null) continue;
            
            var subType = polyAttr.OptionTypes.FirstOrDefault(t => t.IsAssignableFrom(actualType));
            if (subType == null) continue;
            
            var subName = subType.Name;
            if (subName.EndsWith("Options"))
                subName = subName.Substring(0, subName.Length - "Options".Length);
            subName = subName.ToSnakeCase();
            var subTable = $"{_tableName}_{subName}";
            var alias = $"pt{childTableInfos.Count + 1}";
            var columnName = $"{alias}.{prop.Name.ToSnakeCase()}";
            
            if (firstRow.GetOrdinal(columnName) >= 0)
            {
                var value = firstRow[columnName];
                if (value != DBNull.Value)
                {
                    prop.SetValue(result, ConvertValue(value, prop.PropertyType));
                }
            }
        }

        // Map child table properties
        foreach (var childInfo in childTableInfos)
        {
            var prop = childInfo.Property;
            var childType = childInfo.ChildType;

            if (childInfo.IsSimple)
            {
                // Simple type - get from first row
                var columnName = $"{childInfo.Alias}.{prop.Name.ToSnakeCase()}";
                if (firstRow.GetOrdinal(columnName) >= 0)
                {
                    var value = firstRow[columnName];
                    if (value != DBNull.Value)
                    {
                        prop.SetValue(result, ConvertValue(value, prop.PropertyType));
                    }
                }
            }
            else
            {
                // Complex type - create list
                var listType = typeof(List<>).MakeGenericType(childType);
                var list = Activator.CreateInstance(listType);
                var addMethod = listType.GetMethod("Add");

                foreach (var row in rows)
                {
                    var childItem = Activator.CreateInstance(childType);
                    var childProps = childType.GetProperties(BindingFlags.Public | BindingFlags.Instance);

                    foreach (var childProp in childProps)
                    {
                        var childColumnName = $"{childInfo.Alias}.{childProp.Name.ToSnakeCase()}";
                        if (row.GetOrdinal(childColumnName) >= 0)
                        {
                            var value = row[childColumnName];
                            if (value != DBNull.Value)
                            {
                                childProp.SetValue(childItem, ConvertValue(value, childProp.PropertyType));
                            }
                        }
                    }

                    addMethod?.Invoke(list, new[] { childItem });
                }

                prop.SetValue(result, list);
            }
        }

        return result;
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
        using var connection = new FbConnection(_connectionString);
        connection.Open();
        using var transaction = connection.BeginTransaction();
        try
        {
            InsertIntoMainTable(connection, item);
            InsertIntoPolymorphicTables(connection, item);
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
        var sb = new StringBuilder();
        foreach (var item in items)
        {
            sb.AppendLine(BuildInsertMainTableSql(item, true));
            sb.AppendLine(BuildInsertPolymorphicTablesSql(item, true));
            sb.AppendLine(BuildInsertChildTablesSql(item, true));
        }
        return sb.ToString();
    }

    private string BuildInsertMainTableSql(TClass item, bool asText)
    {
        var columns = GetDirectColumns();
        var values = string.Join(", ", _directProperties.Select(p => $"@{p.Name.ToSnakeCase()}"));
        return $"INSERT INTO {_tableName} ({columns}) VALUES ({values})";
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
            var sqlValue = asText ? ToSqlLiteral(value) : $"@{prop.Name.ToSnakeCase()}";
            sb.AppendLine($"INSERT INTO {subTable} ({_primaryKeyColumn}, {prop.Name.ToSnakeCase()}) VALUES ({GetPrimaryKeyValue(item)}, {sqlValue})");
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
            
            var childTableName = childAttr.GetTableName(prop, typeof(TClass));
            var value = prop.GetValue(item);
            if (value != null)
            {
                var childType = GetChildTypeFromProperty(prop);
                if (childType != null)
                {
                    if (typeof(System.Collections.IEnumerable).IsAssignableFrom(prop.PropertyType) && prop.PropertyType != typeof(string))
                    {
                        var enumerable = (System.Collections.IEnumerable)value;
                        foreach (var childItem in enumerable)
                        {
                            var childProps = childType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                            var childColumns = string.Join(", ", childProps.Select(p => p.Name.ToSnakeCase()));
                            var childValues = string.Join(", ", childProps.Select(p => asText ? ToSqlLiteral(p.GetValue(childItem)) : $"@{p.Name.ToSnakeCase()}"));
                            sb.AppendLine($"INSERT INTO {childTableName} ({_primaryKeyColumn}, {childColumns}) VALUES ({GetPrimaryKeyValue(item)}, {childValues})");
                        }
                    }
                    else
                    {
                        var childProps = childType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                        var childColumns = string.Join(", ", childProps.Select(p => p.Name.ToSnakeCase()));
                        var childValues = string.Join(", ", childProps.Select(p => asText ? ToSqlLiteral(p.GetValue(value)) : $"@{p.Name.ToSnakeCase()}"));
                        sb.AppendLine($"INSERT INTO {childTableName} ({_primaryKeyColumn}, {childColumns}) VALUES ({GetPrimaryKeyValue(item)}, {childValues})");
                    }
                }
            }
        }
        return sb.ToString();
    }

    private string ToSqlLiteral(object? value)
    {
        if (value == null) return "NULL";
        if (value is string str) return $"'{str.Replace("'", "''")}'";
        if (value is DateTime dt) return $"'{dt:yyyy-MM-dd HH:mm:ss}'";
        if (value is bool b) return b ? "1" : "0";
        return value.ToString() ?? "NULL";
    }

    private void InsertIntoMainTable(FbConnection connection, TClass item)
    {
        var sql = BuildInsertMainTableSql(item, false);
        using var command = new FbCommand(sql, connection);
        foreach (var prop in _directProperties)
        {
            var value = GetPropertyValueForDb(prop, item);
            command.Parameters.AddWithValue($"@{prop.Name.ToSnakeCase()}", value ?? DBNull.Value);
        }
        command.ExecuteNonQuery();
    }

    private void InsertIntoPolymorphicTables(FbConnection connection, TClass item)
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
            
            var subName = subType.Name;
            if (subName.EndsWith("Options"))
                subName = subName.Substring(0, subName.Length - "Options".Length);
            subName = subName.ToSnakeCase();
            var subTable = $"{_tableName}_{subName}";
            var sql = $"INSERT INTO {subTable} ({_primaryKeyColumn}, {prop.Name.ToSnakeCase()}) VALUES (@id, @value)";
            using var command = new FbCommand(sql, connection);
            command.Parameters.AddWithValue("@id", GetPrimaryKeyValue(item));
            command.Parameters.AddWithValue("@value", value);
            command.ExecuteNonQuery();
        }
    }

    private void InsertIntoChildTables(FbConnection connection, TClass item)
    {
        foreach (var prop in _allProperties)
        {
            var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
            if (childAttr == null) continue;
            
            var childTableName = childAttr.GetTableName(prop, typeof(TClass));
            var value = prop.GetValue(item);
            if (value != null)
            {
                var childType = GetChildTypeFromProperty(prop);
                if (childType != null)
                {
                    if (typeof(System.Collections.IEnumerable).IsAssignableFrom(prop.PropertyType) && prop.PropertyType != typeof(string))
                    {
                        var enumerable = (System.Collections.IEnumerable)value;
                        foreach (var childItem in enumerable)
                        {
                            var childProps = childType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                            var sql = $"INSERT INTO {childTableName} ({_primaryKeyColumn}, {string.Join(", ", childProps.Select(p => p.Name.ToSnakeCase()))}) VALUES (@id, {string.Join(", ", childProps.Select(p => $"@{p.Name.ToSnakeCase()}"))})";
                            using var command = new FbCommand(sql, connection);
                            command.Parameters.AddWithValue("@id", GetPrimaryKeyValue(item));
                            foreach (var childProp in childProps)
                            {
                                var childValue = GetPropertyValueForDb(childProp, childItem);
                                command.Parameters.AddWithValue($"@{childProp.Name.ToSnakeCase()}", childValue ?? DBNull.Value);
                            }
                            command.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        var childProps = childType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                        var sql = $"INSERT INTO {childTableName} ({_primaryKeyColumn}, {string.Join(", ", childProps.Select(p => p.Name.ToSnakeCase()))}) VALUES (@id, {string.Join(", ", childProps.Select(p => $"@{p.Name.ToSnakeCase()}"))})";
                        using var command = new FbCommand(sql, connection);
                        command.Parameters.AddWithValue("@id", GetPrimaryKeyValue(item));
                        foreach (var childProp in childProps)
                        {
                            var childValue = GetPropertyValueForDb(childProp, value);
                            command.Parameters.AddWithValue($"@{childProp.Name.ToSnakeCase()}", childValue ?? DBNull.Value);
                        }
                        command.ExecuteNonQuery();
                    }
                }
            }
        }
    }

    private TId GetPrimaryKeyValue(TClass item)
    {
        var primaryKeyProp = _directProperties.FirstOrDefault(p => p.GetCustomAttribute<DbPrimaryKeyAttribute>() != null);
        if (primaryKeyProp == null)
            throw new InvalidOperationException("Primary key property not found");
        return (TId)primaryKeyProp.GetValue(item)!;
    }

    private Type? GetChildTypeFromProperty(PropertyInfo prop)
    {
        if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(List<>))
        {
            return prop.PropertyType.GetGenericArguments()[0];
        }
        return prop.PropertyType;
    }

    public void Update(TId id, TClass item)
    {
        Delete(id);
        Create(item);
    }

    public void Delete(TId id)
    {
        using var connection = new FbConnection(_connectionString);
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
                    var sql = $"DELETE FROM {subTable} WHERE {_primaryKeyColumn} = @id";
                    using var command = new FbCommand(sql, connection, transaction);
                    command.Parameters.AddWithValue("@id", id);
                    command.ExecuteNonQuery();
                }
            }

            // 2. Delete from all child tables
            foreach (var prop in _allProperties)
            {
                var childAttr = prop.GetCustomAttribute<DbChildTableAttribute>();
                if (childAttr == null) continue;
                var childTableName = childAttr.GetTableName(prop, typeof(TClass));
                var sql = $"DELETE FROM {childTableName} WHERE {_primaryKeyColumn} = @id";
                using var command = new FbCommand(sql, connection, transaction);
                command.Parameters.AddWithValue("@id", id);
                command.ExecuteNonQuery();
            }

            // 3. Delete from main table
            var mainTableSql = $"DELETE FROM {_tableName} WHERE {_primaryKeyColumn} = @id";
            using var mainCommand = new FbCommand(mainTableSql, connection, transaction);
            mainCommand.Parameters.AddWithValue("@id", id);
            mainCommand.ExecuteNonQuery();

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
        return string.Join(", ", _directProperties.Select(p => p.Name.ToSnakeCase()));
    }

    private object GetPropertyValueForDb(PropertyInfo prop, object item)
    {
        var value = prop.GetValue(item);
        if (value == null) return DBNull.Value;
        return ConvertValue(value, prop.PropertyType);
    }

    private static object ConvertValue(object value, Type targetType)
    {
        if (value == null) return DBNull.Value;
        if (targetType.IsAssignableFrom(value.GetType())) return value;
        if (targetType == typeof(string)) return value.ToString() ?? "";
        if (targetType == typeof(int)) return Convert.ToInt32(value);
        if (targetType == typeof(long)) return Convert.ToInt64(value);
        if (targetType == typeof(double)) return Convert.ToDouble(value);
        if (targetType == typeof(decimal)) return Convert.ToDecimal(value);
        if (targetType == typeof(bool)) return Convert.ToBoolean(value);
        if (targetType == typeof(DateTime)) return Convert.ToDateTime(value);
        if (targetType == typeof(Guid)) return (Guid)value;
        if (targetType.IsEnum) return Convert.ToInt32(value);
        return value;
    }

    private class DataRecordSnapshot : IDataRecord
    {
        private readonly object[] _values;
        private readonly string[] _names;

        public DataRecordSnapshot(IDataReader reader, object[] values)
        {
            _values = values;
            _names = new string[reader.FieldCount];
            for (int i = 0; i < reader.FieldCount; i++)
            {
                _names[i] = reader.GetName(i);
            }
        }

        public int FieldCount => _values.Length;
        public string GetName(int i) => _names[i];
        public IDataReader GetData(int i) => throw new NotSupportedException();
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

        // Indexer implementations
        public object this[int i] => _values[i];
        public object this[string name] => _values[GetOrdinal(name)];
    }

    public IList<TClass> GetByField(string fieldName, object value)
    {
        var (resolvedFieldName, convertedValue) = ResolveFieldNameAndConvertValue(fieldName, value);
        var whereClause = $"{resolvedFieldName} = @value";
        var parameters = new Dictionary<string, object> { ["@value"] = convertedValue };
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
            var paramName = $"@param{parameters.Count}";
            whereConditions.Add($"{resolvedFieldName} = {paramName}");
            parameters[paramName] = convertedValue;
        }

        var whereClause = string.Join(" AND ", whereConditions);
        return GetByWhere(whereClause, parameters);
    }

    public IList<TClass> GetByWhere(string whereClause, Dictionary<string, object>? parameters = null)
    {
        var (sql, queryParams, childTableInfos) = BuildMegaJoinQueryWithWhere(whereClause, parameters);
        var result = new List<TClass>();
        using var connection = new FbConnection(_connectionString);
        connection.Open();
        using var command = new FbCommand(sql, connection);
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
        // Group by id
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
        using var connection = new FbConnection(_connectionString);
        connection.Open();
        var sql = $"SELECT COUNT(*) FROM {_tableName} WHERE {resolvedFieldName} = @value";
        using var command = new FbCommand(sql, connection);
        command.Parameters.AddWithValue("@value", convertedValue);
        var count = Convert.ToInt32(command.ExecuteScalar());
        return count > 0;
    }

    private (string resolvedFieldName, object convertedValue) ResolveFieldNameAndConvertValue(string fieldName, object value)
    {
        // Find the property by name (case-insensitive)
        var prop = _directProperties.FirstOrDefault(p => 
            string.Equals(p.Name, fieldName, StringComparison.OrdinalIgnoreCase) ||
            string.Equals(p.Name.ToSnakeCase(), fieldName, StringComparison.OrdinalIgnoreCase));

        if (prop == null)
            throw new ArgumentException($"Field '{fieldName}' not found in type {typeof(TClass).Name}");

        var resolvedFieldName = prop.Name.ToSnakeCase();
        var convertedValue = ConvertValueForField(fieldName, value);
        return (resolvedFieldName, convertedValue);
    }

    private object ConvertValueForField(string fieldName, object value)
    {
        var prop = _directProperties.FirstOrDefault(p => 
            string.Equals(p.Name, fieldName, StringComparison.OrdinalIgnoreCase) ||
            string.Equals(p.Name.ToSnakeCase(), fieldName, StringComparison.OrdinalIgnoreCase));

        if (prop == null)
            return value;

        return ConvertValue(value, prop.PropertyType);
    }

    private (string sql, Dictionary<string, object> parameters, List<ChildTableJoinInfo> childTableInfos) BuildMegaJoinQueryWithWhere(string whereClause, Dictionary<string, object>? parameters)
    {
        var (baseSql, baseParams, childTableInfos) = BuildMegaJoinQuery(null);
        var allParams = new Dictionary<string, object>(baseParams);
        
        if (parameters != null)
        {
            foreach (var param in parameters)
            {
                allParams[param.Key] = param.Value;
            }
        }

        var sql = baseSql + (string.IsNullOrEmpty(whereClause) ? "" : $" WHERE {whereClause}");
        return (sql, allParams, childTableInfos);
    }

    private string[] GetChildTableColumns(PropertyInfo prop, Type childType)
    {
        var childProps = childType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
        return childProps.Select(p => p.Name.ToSnakeCase()).ToArray();
    }
} 