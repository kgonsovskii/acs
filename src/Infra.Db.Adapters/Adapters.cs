namespace Infra.Db.AllAdapters;

public static class Adapters
{
    public static IDbAdapter<TItem, TId> GetAdapter<TItem, TId>(SqlDialect dialect, string connectionString) 
        where TItem : class 
        where TId : struct
    {
        if (dialect == SqlDialect.Postgres)
            return new PostgresDbAdapter<TItem, TId>(connectionString);
        throw new NotImplementedException("Not implemented");
    }
}
