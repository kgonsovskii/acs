namespace Infra.Db;

public interface IDbAdapter<TClass, TId> where TClass : class
{
    IList<TClass> GetAll();
    void SetAll(IEnumerable<TClass> all);
    TClass? GetById(TId id);
    void Create(TClass item);
    void Update(TId id, TClass item);
    void Delete(TId id);
    bool Detached { get; set; }
    string DumpSql(IEnumerable<TClass> items);
}
