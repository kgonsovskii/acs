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

public interface IBaseStorage<TItem, in TId> where TItem : IItem<TId>
{
    public IEnumerable<TItem> GetAll();
    public void SetAll(IEnumerable<TItem> all);
    public TItem? GetById(TId id);
    public void Create(TItem item);
    public void Update(TItem item);
    public void Delete(TId id);
}

public class BaseStorage<TItem, TId> : BaseStorageBase, IBaseStorage<TItem, TId> where TItem : IItem<TId>
{
    private IBaseStorage<TItem, TId> _storage;
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
    public virtual IEnumerable<TItem> GetAll()
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
        _storage.Create(item);
    }

    public virtual void Update(TItem item)
    {
        _storage.Update(item);
    }

    public virtual void Delete(TId id)
    {
        _storage.Delete(id);
    }
}
