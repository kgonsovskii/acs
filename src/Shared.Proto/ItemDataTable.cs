using System.Data;
using System.Reflection;

namespace SevenSeals.Tss.Shared;

public class ItemDataTable<T> : DataTable
{
    private readonly List<PropertyPath> _propertyPaths = new();
    private const string ItemColumnName = "_Item";

    public ItemDataTable(IEnumerable<T> items)
    {
        BuildColumns(items);
        Columns.Add(ItemColumnName, typeof(T)); // hidden column for the item reference
        Columns[ItemColumnName].ColumnMapping = MappingType.Hidden;
        foreach (var item in items)
        {
            var row = NewRow();
            row[ItemColumnName] = item;
            foreach (var path in _propertyPaths)
            {
                row[path.FullName] = path.GetValue(item) ?? DBNull.Value;
            }
            Rows.Add(row);
        }
        // Handle changes to sync with TItem
        this.ColumnChanging += ItemDataTable_ColumnChanging;
    }

    public T GetItem(int rowIndex) => (T)Rows[rowIndex][ItemColumnName];
    public T GetItem(DataRow row) => (T)row[ItemColumnName];

    private void ItemDataTable_ColumnChanging(object? sender, DataColumnChangeEventArgs e)
    {
        if (e.Column.ColumnName == ItemColumnName) return;
        var item = (T)e.Row[ItemColumnName];
        var path = _propertyPaths.FirstOrDefault(p => p.FullName == e.Column.ColumnName);
        path?.SetValue(item, e.ProposedValue);
    }

    private void BuildColumns(IEnumerable<T> items)
    {
        var visitedPaths = new HashSet<string>();
        var pathTypeMap = new Dictionary<string, HashSet<Type>>();
        foreach (var item in items)
            CollectAllTypesPerPath(item, "", pathTypeMap, visitedPaths, 0);

        foreach (var path in _propertyPaths)
        {
            Columns.Add(path.FullName, path.Type);
        }
    }

    private void CollectAllTypesPerPath(object? obj, string prefix, Dictionary<string, HashSet<Type>> pathTypeMap, HashSet<string> visited, int level)
    {
        if (level >= 2)
            return;
        if (obj == null) return;
        var type = obj.GetType();
        foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
        {
            var propType = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
            var name = string.IsNullOrEmpty(prefix) ? prop.Name : prefix + "." + prop.Name;
            if (!pathTypeMap.ContainsKey(name))
                pathTypeMap[name] = new HashSet<Type>();
            var value = prop.GetValue(obj);
            CollectPropertyDeclaredOnly(prop, prefix, visited);
            if (IsUserDefinedClass(propType))
            {
                if (value != null)
                {
                    if (pathTypeMap[name].Add(value.GetType()))
                        CollectAllTypesPerPath(value, name, pathTypeMap, visited, level + 1);
                }
                else
                {
                    if (pathTypeMap[name].Add(propType))
                        CollectAllTypesPerPath(Activator.CreateInstance(propType), name, pathTypeMap, visited, level + 1);
                }
            }
            else
            {
                pathTypeMap[name].Add(propType);
            }
        }
    }

    private void CollectPropertiesDeclaredOnly(Type type, string prefix, HashSet<string> visited)
    {
        foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly))
        {
            CollectPropertyDeclaredOnly(prop, prefix, visited);
        }
    }

    private void CollectPropertyDeclaredOnly(PropertyInfo prop, string prefix, HashSet<string> visited)
    {
        if (prop.GetIndexParameters().Length > 0) return;
        var propType = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
        var name = string.IsNullOrEmpty(prefix) ? prop.Name : prefix + "." + prop.Name;
        if (!visited.Add(propType.FullName + "." + name)) return;
        if (_propertyPaths.Any(p => p.FullName == name)) return;
        _propertyPaths.Add(new PropertyPath(name, propType));
    }

    private static bool IsUserDefinedClass(Type t)
    {
        return t.IsClass && t != typeof(string) && !t.IsEnum && t != typeof(DateTime) && !t.IsPrimitive;
    }

    private class PropertyPath
    {
        public string FullName { get; }
        public Type Type { get; }
        private readonly string[] _parts;
        public PropertyPath(string fullName, Type type)
        {
            FullName = fullName;
            Type = type;
            _parts = fullName.Split('.');
        }
        public object? GetValue(object obj)
        {
            object? current = obj;
            foreach (var part in _parts)
            {
                if (current == null) return null;
                var prop = current.GetType().GetProperty(part, BindingFlags.Public | BindingFlags.Instance);
                if (prop == null) return null;
                current = prop.GetValue(current);
            }
            return current;
        }
        public void SetValue(object obj, object? value)
        {
            object? current = obj;
            for (int i = 0; i < _parts.Length - 1; i++)
            {
                if (current == null) return;
                var prop = current.GetType().GetProperty(_parts[i], BindingFlags.Public | BindingFlags.Instance);
                if (prop == null) return;
                current = prop.GetValue(current);
            }
            var lastProp = current?.GetType().GetProperty(_parts.Last(), BindingFlags.Public | BindingFlags.Instance);
            if (lastProp != null && current != null)
                lastProp.SetValue(current, value);
        }
    }
}
