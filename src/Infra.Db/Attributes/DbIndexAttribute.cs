namespace Infra.Db.Attributes;

[AttributeUsage(AttributeTargets.Property)]
public class DbIndexAttribute : Attribute
{
    public string? Name { get; set; }
    public bool IsUnique { get; set; }
} 