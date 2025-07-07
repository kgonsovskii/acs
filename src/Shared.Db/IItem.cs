using Infra.Db.Attributes;

namespace SevenSeals.Tss.Shared;

public interface IItem
{
    string GetId();
}
public interface IItem<TId>: IItem
{
    [DbPrimaryKey] public TId Id {get; set; }
}

public interface IStructuralItem<TId>: IItem<TId>
{
    [DbNull] public string? Name { get; set; }
    [DbNull] public string? Hint { get; set; }
    public bool IsActive { get; set; }
}


public class Item<TId>: IItem<TId>
{
    [DbPrimaryKey] public TId Id {get; set; }
    public string GetId()
    {
        return Id.ToString();
    }
}


public class StructuralItem<TId>: Item<TId>, IStructuralItem<TId>
{
    [DbNull] public string? Name { get; set; }
    [DbNull] public string? Hint { get; set; }
    public bool IsActive { get; set; }
}
