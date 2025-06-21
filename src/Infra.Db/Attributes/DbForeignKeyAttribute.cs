namespace Infra.Db.Attributes;

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