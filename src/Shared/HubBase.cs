using System.Collections;
using System.Collections.Concurrent;

namespace SevenSeals.Tss.Shared;

public abstract class HubBase<TKey, T> : IEnumerable<T> where TKey : notnull
{
    public readonly ConcurrentDictionary<TKey, T> Map = new();

    public T Add(TKey key, T item)
    {
        Map[key] = item;
        return item;
    }

    public void Remove(TKey key)
    {
        Map.TryRemove(key, out _);
    }

    public IEnumerator<T> GetEnumerator()
    {
        return Map.Values.ToList().GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }

    public virtual void Clear()
    {

    }
}

public abstract class HubBase<T> : IEnumerable<T>
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
