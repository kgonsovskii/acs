namespace Infra.Db;

public abstract class DatabaseGeneratorTestBase
{
    protected abstract IDatabaseGenerator DatabaseGenerator { get; }

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
