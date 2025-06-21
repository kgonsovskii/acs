using System.Reflection;

namespace Infra.Db.Attributes;

[AttributeUsage(AttributeTargets.Property)]
public class DbChildTableAttribute : Attribute
{
    public string? TableName { get; set; }
    public string? Schema { get; set; }
    public string? ForeignKeyColumnName { get; set; }

    public string GetTableName(PropertyInfo property, Type parentType)
    {
        if (!string.IsNullOrEmpty(TableName))
            return TableName;

        var parentTableName = parentType.GetCustomAttribute<DbTableAttribute>()?.GetTableName(parentType) ?? parentType.Name.ToSnakeCase();
        var childTableName = BaseNameModifier(property.Name).ToSnakeCase();

        return $"{parentTableName}_{childTableName}";
    }

    public string GetSchemaName(Type parentType) => parentType.GetSchemaName(Schema);

    public string GetForeignKeyColumnName(Type parentType)
    {
        if (!string.IsNullOrEmpty(ForeignKeyColumnName))
            return ForeignKeyColumnName;

        var parentTableName = parentType.GetCustomAttribute<DbTableAttribute>()?.GetTableName(parentType) ?? parentType.Name.ToSnakeCase();
        return $"{parentTableName}_id";
    }

    private static string GetChildForeignKeyColumnName(Type childType)
    {
        var childTableName = childType.GetCustomAttribute<DbTableAttribute>()?.GetTableName(childType) ?? childType.Name.ToSnakeCase();
        return $"{childTableName}_id";
    }

    public string GetChildForeignKeyColumnName(Type parentType, Type childType, string propertyName)
    {
        if (parentType != childType || string.IsNullOrEmpty(propertyName))
            return GetChildForeignKeyColumnName(childType);
        var baseName = BaseNameModifier(propertyName);
        return baseName.ToSnakeCase() + "_id";
    }

    private static string BaseNameModifier(string baseName)
    {
        // Handle common English plural forms
        if (baseName.EndsWith("ren")) baseName = baseName.Substring(0, baseName.Length - 3); // children -> child
        else if (baseName.EndsWith("ies")) baseName = baseName.Substring(0, baseName.Length - 3) + "y"; // companies -> company
        else if (baseName.EndsWith("es")) baseName = baseName.Substring(0, baseName.Length - 2); // addresses -> address
        else if (baseName.EndsWith("s")) baseName = baseName.Substring(0, baseName.Length - 1); // tasks -> task
        return baseName;
    }
}
