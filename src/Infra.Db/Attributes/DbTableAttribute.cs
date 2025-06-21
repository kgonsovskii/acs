namespace Infra.Db.Attributes;

[AttributeUsage(AttributeTargets.Class)]
public class DbTableAttribute : Attribute
{
    public string? TableName { get; set; }
    public string? Schema { get; set; }

    public string GetTableName(Type type) => TableName ?? type.Name.ToSnakeCase();
    public string GetSchemaName(Type type) => type.GetSchemaName(Schema);
} 