namespace Infra.Db;

public abstract class SchemaGeneratorTestBase
{
    protected abstract ISchemaGenerator SchemaGenerator { get; }

    public abstract void GenerateCreateTableSql_UserModel_Works();

    public abstract void GenerateCreateTableSql_PostModel_Works();

    public abstract void GenerateCreateTableSql_Throws_IfNoTableAttribute();

    public abstract void GenerateCreateTableSql_WithIndexAttributes_GeneratesIndexes();

    public abstract void GenerateCreateTableSql_WithCsvStringAttribute_ColumnIsText();

    public abstract void SchemaGenerator_HandlesNullableTypes();

    public abstract void SchemaGenerator_HandlesPrimaryKeyWithNullableType();

    public abstract void CsvString_Serialization_Works();
}
