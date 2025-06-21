using Infra.Db;
using Infra.Db.Attributes;

namespace SevenSeals.Tss.Shared;

public interface IItem<TId>
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
    [DbPrimaryKey] public required TId Id {get; set; }
}

public class StructuralItem<TId>: IStructuralItem<TId>
{
    [DbPrimaryKey] public TId Id { get; set; } = default!;
    [DbNull] public string? Name { get; set; }
    [DbNull] public string? Hint { get; set; }
    public bool IsActive { get; set; }
}
