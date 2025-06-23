namespace Gui.Shared;

public class UpdateRequest<TItem, TId>
{
    public TId Id { get; set; }
    public TItem Item { get; set; }
} 