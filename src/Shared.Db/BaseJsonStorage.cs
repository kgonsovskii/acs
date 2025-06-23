using System.Data;
using Microsoft.Extensions.Logging;
using System.Reflection;

namespace SevenSeals.Tss.Shared;

public class BaseJsonStorage<TItem, TId>: BaseStorageBase, IBaseStorage<TItem, TId> where TItem : IItem<TId> where TId : struct
{
    public BaseJsonStorage(Settings settings, ILogger logger) : base(settings, logger)
    {
    }

    protected List<TItem> Items { get; set; } = [];
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

    public virtual IList<TItem> GetAll()
    {
        LoadData();
        return Items;
    }

    public DataTable GetDataTable()
    {
        throw new NotImplementedException();
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
        return Items.FirstOrDefault(x => x.Id!.Equals(id));
    }

    public virtual void Create(TItem item)
    {
        LoadData();
        Items.Add(item);
        SaveData();
    }

    public virtual void Update(TId id, TItem item)
    {
        LoadData();
        var index = Items.FindIndex(x => x.Id!.Equals(id));
        Items[index] = item;
        SaveData();
    }

    public virtual void Delete(TId id)
    {
        LoadData();
        Items.RemoveAll(x => x.Id!.Equals(id));
        SaveData();
    }

    // Flexible query methods
    public virtual IList<TItem> GetByField(string fieldName, object value)
    {
        LoadData();
        var prop = typeof(TItem).GetProperty(fieldName, BindingFlags.Public | BindingFlags.Instance | BindingFlags.IgnoreCase);
        if (prop == null) throw new ArgumentException($"No property '{fieldName}' on {typeof(TItem).Name}");
        return Items.Where(x => Equals(prop.GetValue(x), value)).ToList();
    }

    public virtual IList<TItem> GetByFields(Dictionary<string, object> criteria)
    {
        LoadData();
        if (criteria == null || criteria.Count == 0) return Items.ToList();
        return Items.Where(x => criteria.All(kv => {
            var prop = typeof(TItem).GetProperty(kv.Key, BindingFlags.Public | BindingFlags.Instance | BindingFlags.IgnoreCase);
            return prop != null && Equals(prop.GetValue(x), kv.Value);
        })).ToList();
    }

    public virtual IList<TItem> GetByWhere(string whereClause, Dictionary<string, object>? parameters = null)
    {
        // For JSON, support only a simple predicate string: "PropertyName == value" or "PropertyName > value" etc.
        // For more complex logic, recommend using GetByFields or GetByField.
        throw new NotSupportedException("GetByWhere is not supported for JSON storage. Use GetByField or GetByFields.");
    }

    public virtual TItem? GetFirstByField(string fieldName, object value)
    {
        LoadData();
        var prop = typeof(TItem).GetProperty(fieldName, BindingFlags.Public | BindingFlags.Instance | BindingFlags.IgnoreCase);
        if (prop == null) throw new ArgumentException($"No property '{fieldName}' on {typeof(TItem).Name}");
        return Items.FirstOrDefault(x => Equals(prop.GetValue(x), value));
    }

    public virtual bool ExistsByField(string fieldName, object value)
    {
        LoadData();
        var prop = typeof(TItem).GetProperty(fieldName, BindingFlags.Public | BindingFlags.Instance | BindingFlags.IgnoreCase);
        if (prop == null) throw new ArgumentException($"No property '{fieldName}' on {typeof(TItem).Name}");
        return Items.Any(x => Equals(prop.GetValue(x), value));
    }
}
