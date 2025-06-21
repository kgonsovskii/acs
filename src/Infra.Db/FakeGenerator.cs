namespace Infra.Db;

public interface IFakeGenerator
{
    string GenerateFakeDataSql(string outputDir);
    string GenerateFakeDataSqlForTypes(IList<Type> types);
}
