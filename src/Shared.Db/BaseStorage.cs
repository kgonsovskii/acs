using Infra;
using Microsoft.Extensions.Logging;

namespace SevenSeals.Tss.Shared;

public abstract class BaseStorageBase
{
    protected Settings Settings { get; }

    protected ILogger Logger { get; }

    public BaseStorageBase(Settings settings, ILogger logger)
    {
        Settings = settings;
        Logger = logger;
    }
}

public interface IBaseStorage<TItem, in TId> where TItem : IItem<TId> where TId : struct
{
    public void SetAll(IList<TItem> items);
    public IList<TItem> GetAll();
    public TItem? GetById(TId id);
    public void Create(TItem item);
    public void Update(TId id, TItem item);
    public void Delete(TId id);

    // Flexible query methods
    IList<TItem> GetByField(string fieldName, object value);
    IList<TItem> GetByFields(Dictionary<string, object> criteria);
    IList<TItem> GetByWhere(string whereClause, Dictionary<string, object>? parameters = null);
    TItem? GetFirstByField(string fieldName, object value);
    bool ExistsByField(string fieldName, object value);
}

public class BaseStorage<TItem, TId> : BaseStorageBase, IBaseStorage<TItem, TId> where TItem : class, IItem<TId> where TId : struct
{
    protected IBaseStorage<TItem, TId> InternalStorage { get; }
    public BaseStorage(Settings settings, ILogger logger) : base(settings, logger)
    {
        if (Settings.StorageType == StorageType.Json)
        {
            InternalStorage = new BaseJsonStorage<TItem, TId>(settings, logger);
        }
        else
        {
            InternalStorage = new BaseDbStorage<TItem, TId>(settings, logger);
        }
    }

    public void SetAll(IList<TItem> items)
    {
        InternalStorage.SetAll(items);
    }

    public virtual IList<TItem> GetAll()
    {
        return InternalStorage.GetAll();
    }

    public virtual TItem? GetById(TId id)
    {
        return InternalStorage.GetById(id);
    }

    public virtual void Create(TItem item)
    {
        item.Id = HashExtensions.NewId<TId>();
        InternalStorage.Create(item);
    }

    public virtual void Update(TId id, TItem item)
    {
        item.Id = id;
        var existingItem = InternalStorage.GetById(id)!;
        existingItem.AssignFrom(item);
        InternalStorage.Update(id, existingItem);
    }

    public virtual void Delete(TId id)
    {
        InternalStorage.Delete(id);
    }

    // Flexible query methods
    public virtual IList<TItem> GetByField(string fieldName, object value) => InternalStorage.GetByField(fieldName, value);
    public virtual IList<TItem> GetByFields(Dictionary<string, object> criteria) => InternalStorage.GetByFields(criteria);
    public virtual IList<TItem> GetByWhere(string whereClause, Dictionary<string, object>? parameters = null) => InternalStorage.GetByWhere(whereClause, parameters);
    public virtual TItem? GetFirstByField(string fieldName, object value) => InternalStorage.GetFirstByField(fieldName, value);
    public virtual bool ExistsByField(string fieldName, object value) => InternalStorage.ExistsByField(fieldName, value);
}
