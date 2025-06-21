namespace Infra.Db;

public interface IDbAdapter<TClass, in TId> where TClass : class
{
    public IEnumerable<TClass> GetAll();
    public void SetAll(IEnumerable<TClass> all);
    public TClass? GetById(TId id);
    public void Create(TClass item);
    public void Update(TId id, TClass item);
    public void Delete(TId id);
}
