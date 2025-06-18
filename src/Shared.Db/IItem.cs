namespace SevenSeals.Tss.Shared;

public interface IItem<TId>
{
    public TId Id {get; set; }
}

public interface IStructuralItem<TId>: IItem<TId>
{
    public string? Name { get; set; }
    public string? Hint { get; set; }
    public bool IsActive { get; set; }
}

public class Item<TId>: IItem<TId>
{
    public required TId Id {get; set; }
}

public class StructuralItem<TId>: IStructuralItem<TId>
{
    public TId Id { get; set; } = default!;
    public string? Name { get; set; }
    public string? Hint { get; set; }
    public bool IsActive { get; set; }
}
