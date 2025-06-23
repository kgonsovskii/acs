using System.Reflection;

namespace Infra.Db.Attributes;

[AttributeUsage(AttributeTargets.Property)]
public class DbForeignKeyAttribute : Attribute
{
    public string ReferenceTable { get; }
    public string ReferenceColumn { get; }
    public string ReferenceSchema { get; }

    public DbForeignKeyAttribute(string referncedSchema, string referenceTable, string referenceColumn)
    {
        ReferenceSchema = referncedSchema;
        ReferenceTable = referenceTable;
        ReferenceColumn = referenceColumn;
    }

    public DbForeignKeyAttribute(Type referenceType)
    {
        // Validate that the type has DbTableAttribute
        var tableAttr = referenceType.GetCustomAttribute<DbTableAttribute>();
        if (tableAttr == null)
            throw new ArgumentException($"Type {referenceType.Name} must be decorated with DbTableAttribute", nameof(referenceType));

        // Get table name from DbTableAttribute
        ReferenceTable = tableAttr.GetTableName(referenceType);

        ReferenceSchema = tableAttr.GetSchemaName(referenceType);

        // Find primary key property
        var primaryKeyProp = referenceType.GetProperties()
            .FirstOrDefault(p => p.GetCustomAttribute<DbPrimaryKeyAttribute>() != null);

        if (primaryKeyProp == null)
            throw new ArgumentException($"Type {referenceType.Name} must have a property decorated with DbPrimaryKeyAttribute", nameof(referenceType));

        // Get primary key column name
        ReferenceColumn = primaryKeyProp.Name.ToSnakeCase();
    }
}
