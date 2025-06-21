namespace Infra.Db.Attributes;

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