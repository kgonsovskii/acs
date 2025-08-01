namespace Infra.Db.AllAdapters;

public class AdapterMapping
{
    public Type AdapterType { get; set; }
    public Type GeneratorType { get; set; }
    public Type FakeGeneratorType { get; set; }
}

public static class Adapters
{
    public static readonly Dictionary<SqlDialect, AdapterMapping> Map = new()
    {
        [SqlDialect.Postgres] = new AdapterMapping
        {
            AdapterType = typeof(PostgresDbAdapter<,>),
            GeneratorType = typeof(PostgresDatabaseGenerator),
            FakeGeneratorType = typeof(GeneralFakeGenerator)
        },
        [SqlDialect.Firebird] = new AdapterMapping
        {
            AdapterType = typeof(FirebirdDbAdapter<,>),
            GeneratorType = typeof(FirebirdDatabaseGenerator),
            FakeGeneratorType = typeof(GeneralFakeGenerator)
        }
    };

    public static IDbAdapter<TItem, TId> GetAdapter<TItem, TId>(SqlDialect dialect, string connectionString)
        where TItem : class
        where TId : struct
    {
        if (Map.TryGetValue(dialect, out var mapping))
        {
            var genericType = mapping.AdapterType.MakeGenericType(typeof(TItem), typeof(TId));
            return (IDbAdapter<TItem, TId>)Activator.CreateInstance(genericType, connectionString)!;
        }
        throw new NotImplementedException($"Dialect {dialect} is not implemented");
    }

    public static IDatabaseGenerator GetGenerator(SqlDialect dialect)
    {
        if (Map.TryGetValue(dialect, out var mapping))
        {
            return (IDatabaseGenerator)Activator.CreateInstance(mapping.GeneratorType)!;
        }
        throw new NotImplementedException($"Dialect {dialect} is not implemented");
    }

    public static IFakeDbGenerator GetFakeGenerator(SqlDialect dialect)
    {
        if (Map.TryGetValue(dialect, out var mapping))
        {
            return (IFakeDbGenerator)Activator.CreateInstance(mapping.FakeGeneratorType)!;
        }
        throw new NotImplementedException($"Dialect {dialect} is not implemented");
    }
}
