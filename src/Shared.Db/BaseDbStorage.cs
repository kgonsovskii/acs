using Infra.Db;
using Infra.Db.AllAdapters;
using Microsoft.Extensions.Logging;

namespace SevenSeals.Tss.Shared;

internal class BaseDbStorage<TItem, TId>: BaseStorageBase, IBaseStorage<TItem, TId> where TItem : class, IItem<TId> where TId : struct
{
    private readonly IDbAdapter<TItem, TId> _adapter;

    public BaseDbStorage(Settings settings, ILogger logger) : base(settings, logger)
    {
        _adapter = Adapters.GetAdapter<TItem, TId>(settings.SqlDialect, settings.ConnectionString);
    }

    public virtual IEnumerable<TItem> GetAll()
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
}
