using System.Text.Json;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor.Storage;

public abstract class BaseJsonStorage<TItem, TId> : IBaseStorage<TItem, TId> where TItem : class
{
    private readonly string _dataPath;
    private readonly List<TItem> _items = new();
    private readonly JsonSerializerOptions _jsonOptions;

    protected BaseJsonStorage(Settings settings, string subFolder)
    {
        _dataPath = Path.Combine(settings.DataDir, subFolder);
        Directory.CreateDirectory(_dataPath);
        _jsonOptions = new JsonSerializerOptions
        {
            WriteIndented = true,
            PropertyNameCaseInsensitive = true,
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        };
        LoadData();
    }

    protected virtual void LoadData()
    {
        var filePath = GetFilePath();
        if (File.Exists(filePath))
        {
            try
            {
                var json = File.ReadAllText(filePath);
                var loadedItems = JsonSerializer.Deserialize<List<TItem>>(json, _jsonOptions);
                if (loadedItems != null)
                {
                    _items.Clear();
                    _items.AddRange(loadedItems);
                }
            }
            catch (Exception ex)
            {
                throw new StorageException($"Failed to load data from {filePath}", ex);
            }
        }
    }

    protected virtual void SaveData()
    {
        var filePath = GetFilePath();
        try
        {
            var json = JsonSerializer.Serialize(_items, _jsonOptions);
            File.WriteAllText(filePath, json);
        }
        catch (Exception ex)
        {
            throw new StorageException($"Failed to save data to {filePath}", ex);
        }
    }

    protected virtual string GetFilePath()
    {
        return Path.Combine(_dataPath, $"{typeof(TItem).Name.ToLower()}.json");
    }

    public virtual IEnumerable<TItem> GetAll()
    {
        return _items.AsReadOnly();
    }

    public virtual TItem? GetById(TId id)
    {
        if (id == null)
        {
            throw new ArgumentNullException(nameof(id));
        }
        return _items.FirstOrDefault(item => GetItemId(item).Equals(id));
    }

    public virtual void Create(TItem item)
    {
        if (item == null)
        {
            throw new ArgumentNullException(nameof(item));
        }

        var id = GetItemId(item);
        if (_items.Any(i => GetItemId(i).Equals(id)))
        {
            throw new StorageException($"Item with id {id} already exists");
        }

        _items.Add(item);
        SaveData();
    }

    public virtual void Update(TItem item)
    {
        if (item == null)
        {
            throw new ArgumentNullException(nameof(item));
        }

        var id = GetItemId(item);
        var index = _items.FindIndex(i => GetItemId(i).Equals(id));
        if (index == -1)
        {
            throw new StorageException($"Item with id {id} not found");
        }

        _items[index] = item;
        SaveData();
    }

    public virtual void Delete(TId id)
    {
        if (id == null)
        {
            throw new ArgumentNullException(nameof(id));
        }

        var count = _items.RemoveAll(item => GetItemId(item).Equals(id));
        if (count > 0)
        {
            SaveData();
        }
    }

    protected abstract TId GetItemId(TItem item);
}

public class StorageException : Exception
{
    public StorageException(string message) : base(message)
    {
    }

    public StorageException(string message, Exception innerException) : base(message, innerException)
    {
    }
} 
} 