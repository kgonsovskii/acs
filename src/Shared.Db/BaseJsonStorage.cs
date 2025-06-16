using Microsoft.Extensions.Logging;

namespace SevenSeals.Tss.Shared;

public class BaseJsonStorage<TItem, TId>: BaseStorageBase, IBaseStorage<TItem, TId> where TItem : IItem<TId>
{
    public BaseJsonStorage(Settings settings, ILogger logger) : base(settings, logger)
    {
    }

    protected List<TItem> Items { get; set; } = new();
    protected virtual string DataFile => Path.Combine(Settings.DataDir, $"{typeof(TItem).Name}.json");

    protected virtual void LoadData()
    {
        try
        {
            if (!File.Exists(DataFile))
                return;
            var json = File.ReadAllText(DataFile);
            Items = json.Deserialize<List<TItem>>()!;
        }
        catch (Exception e)
        {
            Logger.LogError(e, $"Failed to load {DataFile}");
        }
    }

    protected virtual void SaveData()
    {
        try
        {
            var json = Items.Serialize();
            File.WriteAllText(DataFile, json);
        }
        catch (Exception e)
        {
            Logger.LogError(e, $"Failed to save data {DataFile}");
        }
    }

    public virtual IEnumerable<TItem> GetAll()
    {
        LoadData();
        return Items;
    }

    public void SetAll(IEnumerable<TItem> all)
    {
        Items.Clear();
        Items.AddRange(all);
        SaveData();
    }

    public virtual TItem? GetById(TId id)
    {
        LoadData();
        return Items.FirstOrDefault(x => x.Id.Equals(id));
    }

    public virtual void Create(TItem item)
    {
        LoadData();
        Items.Add(item);
        SaveData();
    }

    public virtual void Update(TItem item)
    {
        LoadData();
        var index = Items.IndexOf(item);
        Items[index] = item;
        SaveData();
    }

    public virtual void Delete(TId id)
    {
        LoadData();
        Items.RemoveAll(x => x.Id.Equals(id));
        SaveData();
    }
}
