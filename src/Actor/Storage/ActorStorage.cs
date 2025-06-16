using System.Diagnostics.CodeAnalysis;
using System.Text.Json;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor.Storage;

public interface IActorStorage : IActorStorage<Actor>
{
}

public class ActorStorage : ActorStorage<Actor>, IActorStorage
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public ActorStorage(Settings settings) : base(settings)
    {
    }
}

public interface IActorStorage<TBody>: IBaseStorage<TBody, string> where TBody : Actor
{
}

public class ActorStorage<TBody> : BaseStorage<TBody, string>, IActorStorage<TBody> where TBody : Actor
{
    private readonly string _dataPath;
    private readonly List<TBody> _items = new();

    protected ActorStorage(Settings settings)
    {
        _dataPath = settings.DataDir;
        Directory.CreateDirectory(_dataPath);
        _dataPath = Path.Combine(_dataPath, "actors");
        LoadData();
    }

    protected virtual void LoadData()
    {
        if (File.Exists(_dataPath))
        {
            var json = File.ReadAllText(_dataPath);
            var loadedItems = JsonSerializer.Deserialize<List<TBody>>(json);
            if (loadedItems != null)
            {
                _items.AddRange(loadedItems);
            }
        }
    }

    protected virtual void SaveData()
    {
        var json = JsonSerializer.Serialize(_items, new JsonSerializerOptions { WriteIndented = true });
        File.WriteAllText(_dataPath, json);
    }

    public override IEnumerable<TBody> GetAll()
    {
        return _items;
    }

    public override TBody? GetById(string id)
    {
        return _items.FirstOrDefault(item => GetItemId(item) == id);
    }

    public override void Create(TBody item)
    {
        _items.Add(item);
        SaveData();
    }

    public override void Update(TBody item)
    {
        var index = _items.FindIndex(i => GetItemId(i) == GetItemId(item));
        if (index != -1)
        {
            _items[index] = item;
            SaveData();
        }
    }

    public override void Delete(string id)
    {
        _items.RemoveAll(item => GetItemId(item) == id);
        SaveData();
    }

    private string GetItemId(TBody item)
    {
        return item.Id;
    }
}
