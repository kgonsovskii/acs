using System.Data.Common;
using Microsoft.Extensions.Logging;
using Npgsql;

namespace SevenSeals.Tss.Shared;

internal class BaseDbStorage<TItem, TId>: BaseStorageBase, IBaseStorage<TItem, TId>  where TItem : IItem<TId>
{
    public BaseDbStorage(Settings settings, ILogger logger) : base(settings, logger)
    {
    }

    private DbConnection OpenConnection()
    {
        return new NpgsqlConnection(Settings.ConnectionString);
    }

    protected void Execute(string cmdText)
    {
        using var conn = OpenConnection();
        using var cmd = conn.CreateCommand();
        cmd.CommandText = cmdText;
        cmd.ExecuteNonQuery();
    }

    public virtual IEnumerable<TItem> GetAll()
    {
        throw new NotImplementedException();
    }

    public void SetAll(IEnumerable<TItem> all)
    {
        throw new NotImplementedException();
    }

    public virtual TItem? GetById(TId id)
    {
        throw new NotImplementedException();
    }

    public virtual void Create(TItem item)
    {
        throw new NotImplementedException();
    }

    public virtual void Update(TId id, TItem item)
    {
        throw new NotImplementedException();
    }

    public virtual void Delete(TId id)
    {
        throw new NotImplementedException();
    }
}
