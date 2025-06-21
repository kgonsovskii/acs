namespace Infra.Db;

public interface IDatabaseGenerator
{
    string GenerateDatabaseSql(string outputDir);
    string GenerateDatabaseSqlForTypes(IList<Type> types);
}

public interface IFakeGenerator
{
    string GenerateFakeDataSql(string outputDir);
    string GenerateFakeDataSqlForTypes(IList<Type> types);
}
