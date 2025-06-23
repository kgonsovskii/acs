namespace Gui.WinForms;

public class GetByIdRequest<TId>
{
    public TId Id { get; set; }
}

public class UpdateRequest<TItem, TId>
{
    public TId Id { get; set; }
    public TItem Item { get; set; }
}

public class DeleteRequest<TId>
{
    public TId Id { get; set; }
}

public class CreateRequest<TItem>
{
    public TItem Item { get; set; }
} 