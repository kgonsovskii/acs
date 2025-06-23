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
    public IList<TItem> GetAll();
    public void SetAll(IEnumerable<TItem> all);
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
    private readonly IBaseStorage<TItem, TId> _storage;
    public BaseStorage(Settings settings, ILogger logger) : base(settings, logger)
    {
        if (Settings.StorageType == StorageType.Json)
        {
            _storage = new BaseJsonStorage<TItem, TId>(settings, logger);
        }
        else
        {
            _storage = new BaseDbStorage<TItem, TId>(settings, logger);
        }
    }
    public virtual IList<TItem> GetAll()
    {
        return _storage.GetAll();
    }
    public virtual void SetAll(IEnumerable<TItem> all)
    {
        _storage.SetAll(all);
    }

    public virtual TItem? GetById(TId id)
    {
        return _storage.GetById(id);
    }

    public virtual void Create(TItem item)
    {
        item.Id = HashExtensions.NewId<TId>();
        _storage.Create(item);
    }

    public virtual void Update(TId id, TItem item)
    {
        item.Id = id;
        var existingItem = _storage.GetById(id)!;
        existingItem.AssignFrom(item);
        _storage.Update(id, existingItem);
    }

    public virtual void Delete(TId id)
    {
        _storage.Delete(id);
    }

    // Flexible query methods
    public virtual IList<TItem> GetByField(string fieldName, object value) => _storage.GetByField(fieldName, value);
    public virtual IList<TItem> GetByFields(Dictionary<string, object> criteria) => _storage.GetByFields(criteria);
    public virtual IList<TItem> GetByWhere(string whereClause, Dictionary<string, object>? parameters = null) => _storage.GetByWhere(whereClause, parameters);
    public virtual TItem? GetFirstByField(string fieldName, object value) => _storage.GetFirstByField(fieldName, value);
    public virtual bool ExistsByField(string fieldName, object value) => _storage.ExistsByField(fieldName, value);
}
