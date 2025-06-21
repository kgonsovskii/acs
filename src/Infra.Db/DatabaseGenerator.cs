using System.Reflection;

namespace Infra.Db;

public interface IDatabaseGenerator
{
    string GenerateDatabaseSql(string outputDir);
    string GenerateDatabaseSqlForTypes(IList<Type> types);

    string GenerateCreateTableSql(Type type);

    string GenerateColumnSql(PropertyInfo prop);

    bool IsNullableType(PropertyInfo prop);

    string GetSqlType(Type type, PropertyInfo? prop = null, bool isPrimaryKey = false);
}

public abstract class DatabaseGenerator
{

}
