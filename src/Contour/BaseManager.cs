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
}

public abstract class BaseManager<T> : IEnumerable<T>
{
    private readonly List<T> _items = new();
    private readonly object _lock = new();

    public T Add(T item)
    {
        lock (_lock)
        {
            _items.Add(item);
        }
        return item;
    }

    public void Remove(T item)
    {
        lock (_lock)
        {
            _items.Remove(item);
        }
    }

    public IEnumerator<T> GetEnumerator()
    {
        lock (_lock)
        {
            return _items.GetEnumerator();
        }
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }
}
