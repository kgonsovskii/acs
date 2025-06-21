namespace Infra.Db.Attributes;

[AttributeUsage(AttributeTargets.Property)]
public class DbEnumTableAttribute : Attribute
{
    public string? TableName { get; set; }
    public string? Schema { get; set; }
    public string DescriptionColumnName { get; set; } = "description";

    public string GetTableName(Type enumType) => TableName ?? enumType.Name.ToSnakeCase();
    public string GetSchemaName(Type enumType) => enumType.GetSchemaName(Schema);
} 