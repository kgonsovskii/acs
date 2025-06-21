namespace Infra.Db;

public abstract class DatabaseGeneratorTestBase
{
    protected abstract IDatabaseGenerator DatabaseGenerator { get; }

    public abstract void GenerateCreateTableSql_UserModel_Works();

    public abstract void GenerateCreateTableSql_PostModel_Works();

    public abstract void GenerateCreateTableSql_Throws_IfNoTableAttribute();

    public abstract void GenerateCreateTableSql_WithIndexAttributes_GeneratesIndexes();

    public abstract void GenerateCreateTableSql_WithCsvStringAttribute_ColumnIsText();

    public abstract void SchemaGenerator_HandlesNullableTypes();

    public abstract void SchemaGenerator_HandlesPrimaryKeyWithNullableType();

    public abstract void CsvString_Serialization_Works();

    public abstract void DatabaseGenerator_GeneratesIndexes();
    public abstract void DatabaseGenerator_GeneratesPolymorphicTables();
    public abstract void DatabaseGenerator_GeneratesEnumTables();
    public abstract void DatabaseGenerator_PopulatesEnumData();
    public abstract void DatabaseGenerator_CreatesEnumForeignKeys();
    public abstract void DatabaseGenerator_HandlesEnumWithoutDescription();
    public abstract void GenerateDatabaseSql_WithChildTableAttribute_GeneratesJunctionTables();
}

public class NoTable
{
    public int Id { get; set; }
}
