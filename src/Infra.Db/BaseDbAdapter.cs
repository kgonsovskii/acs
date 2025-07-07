using System.Collections.Concurrent;

namespace Infra.Db;

public abstract class BaseDbAdapter<TClass, TId> : IDbAdapter<TClass, TId>
    where TClass : class
    where TId : struct
{
    // Key: a string representing the query parameters (not values)
    private readonly ConcurrentDictionary<string, object> _sqlRequestCache = new();

    protected TResult GetOrAddSqlRequest<TResult>(string paramKey, Func<TResult> builder)
    {
        // Cache by paramKey (e.g., query type + field names, not values)
        return (TResult)_sqlRequestCache.GetOrAdd(paramKey, _ => builder()!);
    }

    // IDbAdapter methods to be implemented by derived classes
    public abstract IList<TClass> GetAll();
    public abstract void SetAll(IEnumerable<TClass> all);
    public abstract TClass? GetById(TId id);
    public abstract void Create(TClass item);
    public abstract void Update(TId id, TClass item);
    public abstract void Delete(TId id);
    public abstract bool Detached { get; set; }
    public abstract string DumpSql(IEnumerable<TClass> items);
    public abstract IList<TClass> GetByField(string fieldName, object value);
    public abstract IList<TClass> GetByFields(Dictionary<string, object> criteria);
    public abstract IList<TClass> GetByWhere(string whereClause, Dictionary<string, object>? parameters = null);
    public abstract TClass? GetFirstByField(string fieldName, object value);
    public abstract bool ExistsByField(string fieldName, object value);
} 