using Infra.Db;
using Infra.Db.AllAdapters;
using Microsoft.Extensions.Logging;

namespace SevenSeals.Tss.Shared;

public class BaseDbStorage<TItem, TId>: BaseStorageBase, IBaseStorage<TItem, TId> where TItem : class, IItem<TId> where TId : struct
{
    private readonly IDbAdapter<TItem, TId> _adapter;

    public BaseDbStorage(Settings settings, ILogger logger) : base(settings, logger)
    {
        _adapter = Adapters.GetAdapter<TItem, TId>(settings.SqlDialect, settings.ConnectionString);
    }

    public virtual IList<TItem> GetAll()
    {
        return _adapter.GetAll();
    }

    public void SetAll(IEnumerable<TItem> all)
    {
        _adapter.SetAll(all);
    }

    public virtual TItem? GetById(TId id)
    {
        return _adapter.GetById(id);
    }

    public virtual void Create(TItem item)
    {
        _adapter.Create(item);
    }

    public virtual void Update(TId id, TItem item)
    {
        _adapter.Update(id, item);
    }

    public virtual void Delete(TId id)
    {
        _adapter.Delete(id);
    }

    // Flexible query methods
    public virtual IList<TItem> GetByField(string fieldName, object value) => _adapter.GetByField(fieldName, value);
    public virtual IList<TItem> GetByFields(Dictionary<string, object> criteria) => _adapter.GetByFields(criteria);
    public virtual IList<TItem> GetByWhere(string whereClause, Dictionary<string, object>? parameters = null) => _adapter.GetByWhere(whereClause, parameters);
    public virtual TItem? GetFirstByField(string fieldName, object value) => _adapter.GetFirstByField(fieldName, value);
    public virtual bool ExistsByField(string fieldName, object value) => _adapter.ExistsByField(fieldName, value);
}
