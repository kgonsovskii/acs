namespace SevenSeals.Tss.Shared;

public static class ProtoExtensions
{
    public static ItemDataTable<T> ToDataTable<T>(this IList<T> list)
    {
        return new ItemDataTable<T>(list);
    }
}
