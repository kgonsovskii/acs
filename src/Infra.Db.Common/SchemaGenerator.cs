namespace Infra.Db;

public interface ISchemaGenerator
{
    string GenerateCreateTableSql(Type type);
}
