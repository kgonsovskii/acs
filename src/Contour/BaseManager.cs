using System.Collections;
using System.Collections.Concurrent;

namespace SevenSeals.Tss.Contour;

public abstract class BaseManager<TKey, T> : IEnumerable<T> where TKey : notnull
{
    private readonly ConcurrentDictionary<TKey, T> _items = new();

    protected abstract T CreateItem(TKey key);

    public T Add(TKey key)
    {
        var item = CreateItem(key);
        _items[key] = item;
        return item;
    }

    public void Remove(TKey key)
    {
        _items.TryRemove(key, out _);
    }

    public IEnumerator<T> GetEnumerator()
    {
        return _items.Values.ToList().GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }

    public virtual void Clear()
    {

    }
}

public abstract class BaseManager<T> : IEnumerable<T>
{
    protected List<T> Items { get; } = new List<T>();
    protected readonly object Lock = new();

    public T Add(T item)
    {
        lock (Lock)
        {
            Items.Add(item);
        }
        return item;
    }

    public void Remove(T item)
    {
        lock (Lock)
        {
            Items.Remove(item);
        }
    }

    public void Clear()
    {
        lock (Lock)
        {
            Items.Clear();
        }
    }

    public IEnumerator<T> GetEnumerator()
    {
        lock (Lock)
        {
            return Items.GetEnumerator();
        }
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }
}
