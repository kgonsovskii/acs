namespace Infra.Db;

public interface IDatabaseGenerator
{
    string GenerateDatabaseSql(string outputDir);
    string GenerateDatabaseSqlForTypes(IList<Type> types);
}
