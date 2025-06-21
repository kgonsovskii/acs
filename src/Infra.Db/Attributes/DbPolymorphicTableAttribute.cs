namespace Infra.Db.Attributes;

[AttributeUsage(AttributeTargets.Property)]
public class DbPolymorphicTableAttribute : Attribute
{
    public Type[] OptionTypes { get; }

    public DbPolymorphicTableAttribute(params Type[] optionTypes)
    {
        OptionTypes = optionTypes;
    }
} 