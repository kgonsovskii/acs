using System.Reflection;
using Infra.Extensions;

namespace Infra.Db;

[AttributeUsage(AttributeTargets.Class)]
public class DbTableAttribute : Attribute
{
    public string? Name { get; set; }
    public string? Schema { get; set; }

    public string GetTableName(Type type)
    {
        return Name ?? type.Name.ToSnakeCase();
    }

    public string GetSchemaName(Type type)
    {
        return type.GetSchemaName(Schema);
    }
}

[AttributeUsage(AttributeTargets.Property)]
public class DbPrimaryKeyAttribute : Attribute
{
}

[AttributeUsage(AttributeTargets.Property)]
public class DbIndexAttribute : Attribute
{
    public string? Name { get; set; }
    public bool IsUnique { get; set; }
}

[AttributeUsage(AttributeTargets.Class)]
public class DbCompositeIndexAttribute : Attribute
{
    public string[] PropertyNames { get; }
    public string? Name { get; set; }
    public bool IsUnique { get; set; }

    public DbCompositeIndexAttribute(params string[] propertyNames)
    {
        PropertyNames = propertyNames;
    }
}

[AttributeUsage(AttributeTargets.Property)]
public class DbForeignKeyAttribute : Attribute
{
    public string ReferenceTable { get; }
    public string ReferenceColumn { get; }

    public DbForeignKeyAttribute(string referenceTable, string referenceColumn)
    {
        ReferenceTable = referenceTable;
        ReferenceColumn = referenceColumn;
    }
}

[AttributeUsage(AttributeTargets.Property)]
public class DbPolymorphicTableAttribute : Attribute
{
    public Type[] OptionTypes { get; }

    public DbPolymorphicTableAttribute(params Type[] optionTypes)
    {
        OptionTypes = optionTypes;
    }
}

[AttributeUsage(AttributeTargets.Property)]
public class DbEnumTableAttribute : Attribute
{
    public string? TableName { get; set; }
    public string? Schema { get; set; }
    public string? DescriptionColumnName { get; set; }

    public string GetTableName(Type enumType)
    {
        return TableName ?? enumType.Name.ToSnakeCase();
    }

    public string GetSchemaName(Type enumType)
    {
        return enumType.GetSchemaName(Schema);
    }
}

[AttributeUsage(AttributeTargets.Property)]
public class DbCsvStringAttribute : Attribute
{
}

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

    public string GetSchemaName(Type parentType)
    {
        return parentType.GetSchemaName(Schema);
    }

    public string GetForeignKeyColumnName(Type parentType)
    {
        if (!string.IsNullOrEmpty(ForeignKeyColumnName))
            return ForeignKeyColumnName;

        var parentTableName = parentType.GetCustomAttribute<DbTableAttribute>()?.GetTableName(parentType) ?? parentType.Name.ToSnakeCase();
        return $"{parentTableName}Id";
    }

    private static string GetChildForeignKeyColumnName(Type childType)
    {
        var childTableName = childType.GetCustomAttribute<DbTableAttribute>()?.GetTableName(childType) ?? childType.Name.ToSnakeCase();
        return $"{childTableName}Id";
    }

    public string GetChildForeignKeyColumnName(Type parentType, Type childType, string propertyName)
    {
        if (parentType != childType || string.IsNullOrEmpty(propertyName))
            return GetChildForeignKeyColumnName(childType);
        var baseName = BaseNameModifier(propertyName);
        return baseName.ToSnakeCase() + "Id";
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
