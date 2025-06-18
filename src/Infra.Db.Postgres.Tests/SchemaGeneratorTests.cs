using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Infra.Db;

[TestClass]
public class SchemaGeneratorTests
{
    private readonly ISchemaGenerator _schemaGenerator = new PostgresSchemaGenerator();

    [TestMethod]
    public void GenerateCreateTableSql_UserModel_Works()
    {
        var sql = _schemaGenerator.GenerateCreateTableSql(typeof(User));
        sql.Should().Contain("CREATE TABLE \"shared\".\"user\"");
        sql.Should().Contain("\"id\" SERIAL PRIMARY KEY");
        sql.Should().Contain("\"name\" TEXT NOT NULL");
    }

    [TestMethod]
    public void GenerateCreateTableSql_PostModel_Works()
    {
        var sql = _schemaGenerator.GenerateCreateTableSql(typeof(Post));
        sql.Should().Contain("CREATE TABLE \"shared\".\"post\"");
        sql.Should().Contain("\"id\" SERIAL PRIMARY KEY");
        sql.Should().Contain("\"user_id\" INTEGER NOT NULL");
        sql.Should().Contain("\"title\" TEXT NOT NULL");
        sql.Should().Contain("\"slug\" TEXT NOT NULL");
    }

    [TestMethod]
    public void GenerateCreateTableSql_Throws_IfNoTableAttribute()
    {
        Action act = () => _schemaGenerator.GenerateCreateTableSql(typeof(NoTable));
        act.Should().Throw<InvalidOperationException>();
    }

    [TestMethod]
    public void GenerateCreateTableSql_WithIndexAttributes_GeneratesIndexes()
    {
        var sql = _schemaGenerator.GenerateCreateTableSql(typeof(Post));
        sql.Should().Contain("\"user_id\" INTEGER NOT NULL");
        sql.Should().Contain("\"title\" TEXT NOT NULL");
        sql.Should().Contain("\"slug\" TEXT NOT NULL");
    }

    [TestMethod]
    public void DatabaseGenerator_GeneratesIndexes()
    {
        var sql = new PostgresDatabaseGenerator(new PostgresSchemaGenerator()).GenerateDatabaseSqlForTypes([typeof(Post), typeof(User), typeof(Activity)]);
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_post_user_id\" ON \"shared\".\"post\"(\"user_id\")");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_title\" ON \"shared\".\"post\"(\"title\")");
        sql.Should().Contain("CREATE UNIQUE INDEX IF NOT EXISTS \"idx_post_slug\" ON \"shared\".\"post\"(\"slug\")");
        sql.Should().Contain("CREATE UNIQUE INDEX IF NOT EXISTS \"idx_post_user_id_title\" ON \"shared\".\"post\"(\"user_id\", \"title\")");
        sql.Should().Contain("CREATE UNIQUE INDEX IF NOT EXISTS \"idx_user_name\" ON \"shared\".\"user\"(\"name\")");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_activity_user_id\" ON \"shared\".\"activity\"(\"user_id\")");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_activity_timestamp\" ON \"shared\".\"activity\"(\"timestamp\")");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_activity_user_id_timestamp\" ON \"shared\".\"activity\"(\"user_id\", \"timestamp\")");
    }

    [TestMethod]
    public void GenerateCreateTableSql_WithCsvStringAttribute_ColumnIsText()
    {
        var sql = _schemaGenerator.GenerateCreateTableSql(typeof(Taggable));
        sql.Should().Contain("\"tags\" TEXT");
        sql.Should().Contain("\"labels\" TEXT");
    }

    [TestMethod]
    public void CsvString_Serialization_Works()
    {
        var obj = new Taggable { Tags = ["a", "b", "c"], Labels = ["x", "y"] };
        var tagsCsv = string.Join(",", obj.Tags);
        var labelsCsv = string.Join(",", obj.Labels);
        tagsCsv.Should().Be("a,b,c");
        labelsCsv.Should().Be("x,y");

        var restoredTags = tagsCsv.Split(",");
        var restoredLabels = new List<string>(labelsCsv.Split(","));
        restoredTags.Should().BeEquivalentTo(obj.Tags);
        restoredLabels.Should().BeEquivalentTo(obj.Labels);
    }

    [TestMethod]
    public void DatabaseGenerator_GeneratesPolymorphicTables()
    {
        var sql = new PostgresDatabaseGenerator(new PostgresSchemaGenerator()).GenerateDatabaseSqlForTypes([typeof(PolyModel)]);
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"poly_model_ip\"");
        sql.Should().Contain("\"poly_modelId\" UUID REFERENCES \"shared\".\"poly_model\"(\"id\")");
        sql.Should().Contain("\"ip_address\" TEXT");
        sql.Should().Contain("\"port\" INTEGER");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"poly_model_com_port\"");
        sql.Should().Contain("\"poly_modelId\" UUID REFERENCES \"shared\".\"poly_model\"(\"id\")");
        sql.Should().Contain("\"port_name\" TEXT");
        sql.Should().Contain("\"baud_rate\" INTEGER");
    }

    [TestMethod]
    public void DatabaseGenerator_GeneratesEnumTables()
    {
        var sql = new PostgresDatabaseGenerator(new PostgresSchemaGenerator()).GenerateDatabaseSqlForTypes([typeof(Key), typeof(Actor)]);

        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"key_type\" (");
        sql.Should().Contain("\"name\" TEXT PRIMARY KEY");
        sql.Should().Contain("\"description\" TEXT");

        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"key_status\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"actor_types\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"storage_types\"");
    }

    [TestMethod]
    public void DatabaseGenerator_PopulatesEnumData()
    {
        var sql = new PostgresDatabaseGenerator(new PostgresSchemaGenerator()).GenerateDatabaseSqlForTypes([typeof(Key), typeof(Actor)]);

        sql.Should().Contain("INSERT INTO \"shared\".\"key_type\" (\"name\", \"description\") VALUES ('physical', 'Physical')");
        sql.Should().Contain("INSERT INTO \"shared\".\"key_type\" (\"name\", \"description\") VALUES ('virtual', 'Virtual')");
        sql.Should().Contain("INSERT INTO \"shared\".\"key_type\" (\"name\", \"description\") VALUES ('card', 'Card')");
        sql.Should().Contain("INSERT INTO \"shared\".\"key_type\" (\"name\", \"description\") VALUES ('mobile', 'Mobile')");

        sql.Should().Contain("INSERT INTO \"shared\".\"key_status\" (\"name\", \"description\") VALUES ('active', 'Active')");
        sql.Should().Contain("INSERT INTO \"shared\".\"key_status\" (\"name\", \"description\") VALUES ('lost', 'Lost')");

        sql.Should().Contain("INSERT INTO \"shared\".\"actor_types\" (\"name\", \"description\") VALUES ('person', 'Person')");
        sql.Should().Contain("INSERT INTO \"shared\".\"actor_types\" (\"name\", \"description\") VALUES ('drone', 'Drone')");
    }

    [TestMethod]
    public void DatabaseGenerator_CreatesEnumForeignKeys()
    {
        var sql = new PostgresDatabaseGenerator(new PostgresSchemaGenerator()).GenerateDatabaseSqlForTypes([typeof(Key), typeof(Actor)]);

        sql.Should().Contain("ALTER TABLE \"shared\".\"key\" ADD CONSTRAINT \"fk_key_type\" FOREIGN KEY (\"type\") REFERENCES \"shared\".\"key_type\"(\"name\");");
        sql.Should().Contain("ALTER TABLE \"shared\".\"key\" ADD CONSTRAINT \"fk_key_status\" FOREIGN KEY (\"status\") REFERENCES \"shared\".\"key_status\"(\"name\");");
        sql.Should().Contain("ALTER TABLE \"shared\".\"actor\" ADD CONSTRAINT \"fk_actor_type\" FOREIGN KEY (\"type\") REFERENCES \"shared\".\"actor_types\"(\"name\");");
        sql.Should().Contain("ALTER TABLE \"shared\".\"actor\" ADD CONSTRAINT \"fk_actor_preferred_storage\" FOREIGN KEY (\"preferred_storage\") REFERENCES \"shared\".\"storage_types\"(\"name\");");
    }

    [TestMethod]
    public void DatabaseGenerator_HandlesEnumWithoutDescription()
    {
        var sql = new PostgresDatabaseGenerator(new PostgresSchemaGenerator()).GenerateDatabaseSqlForTypes([typeof(PolyModel)]);

        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"channel_type\"");
        sql.Should().Contain("\"name\" TEXT PRIMARY KEY");
        sql.Should().NotContain("\"description\" TEXT");

        sql.Should().Contain("INSERT INTO \"shared\".\"channel_type\" (\"name\") VALUES ('ip')");
        sql.Should().Contain("INSERT INTO \"shared\".\"channel_type\" (\"name\") VALUES ('com_port')");
    }

    [TestMethod]
    public void SchemaGenerator_HandlesNullableTypes()
    {
        var sql = _schemaGenerator.GenerateCreateTableSql(typeof(NullableTestModel));

        sql.Should().Contain("\"nullable_string\" TEXT NULL");
        sql.Should().Contain("\"required_string\" TEXT NOT NULL");

        sql.Should().Contain("\"nullable_int\" INTEGER NULL");
        sql.Should().Contain("\"required_int\" INTEGER NOT NULL");

        sql.Should().Contain("\"nullable_long\" BIGINT NULL");
        sql.Should().Contain("\"required_long\" BIGINT NOT NULL");

        sql.Should().Contain("\"nullable_date_time\" DATETIME NULL");
        sql.Should().Contain("\"required_date_time\" DATETIME NOT NULL");

        sql.Should().Contain("\"nullable_bool\" BOOLEAN NULL");
        sql.Should().Contain("\"required_bool\" BOOLEAN NOT NULL");

        sql.Should().Contain("\"nullable_double\" REAL NULL");
        sql.Should().Contain("\"required_double\" REAL NOT NULL");

        sql.Should().Contain("\"nullable_guid\" UUID NULL");
        sql.Should().Contain("\"required_guid\" UUID NOT NULL");

        sql.Should().Contain("\"nullable_byte\" SMALLINT NULL");
        sql.Should().Contain("\"required_byte\" SMALLINT NOT NULL");

        sql.Should().Contain("\"nullable_key_type\" TEXT NULL");
        sql.Should().Contain("\"required_key_type\" TEXT NOT NULL");

        sql.Should().Contain("\"nullable_string_array\" TEXT NULL");
        sql.Should().Contain("\"required_string_array\" TEXT NOT NULL");

        sql.Should().Contain("\"nullable_string_list\" TEXT NULL");
        sql.Should().Contain("\"required_string_list\" TEXT NOT NULL");
    }

    [TestMethod]
    public void SchemaGenerator_HandlesPrimaryKeyWithNullableType()
    {
        var sql = _schemaGenerator.GenerateCreateTableSql(typeof(User));
        sql.Should().Contain("\"id\" SERIAL PRIMARY KEY");
    }

    [TestMethod]
    public void GenerateDatabaseSql_WithChildTableAttribute_GeneratesJunctionTables()
    {
        var generator = new PostgresDatabaseGenerator(new PostgresSchemaGenerator());
        var types = new List<Type> { typeof(Zone), typeof(Department), typeof(Employee), typeof(Project), typeof(TaskX), typeof(TeamMember) };

        var sql = generator.GenerateDatabaseSqlForTypes(types);

        sql.Should().Contain("-- Child tables");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"zone_zone\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"department_employee\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"project_task\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"project_team_member\"");

        sql.Should().Contain("\"zoneId\" UUID REFERENCES \"shared\".\"zone\"(\"id\")");
        sql.Should().Contain("\"childId\" UUID REFERENCES \"shared\".\"zone\"(\"id\")");
        sql.Should().Contain("\"departmentId\" UUID REFERENCES \"shared\".\"department\"(\"id\")");
        sql.Should().Contain("\"employeeId\" UUID REFERENCES \"shared\".\"employee\"(\"id\")");
        sql.Should().Contain("\"projectId\" UUID REFERENCES \"shared\".\"project\"(\"id\")");
        sql.Should().Contain("\"taskId\" UUID REFERENCES \"shared\".\"task\"(\"id\")");
        sql.Should().Contain("\"projectId\" UUID REFERENCES \"shared\".\"project\"(\"id\")");
        sql.Should().Contain("\"team_memberId\" UUID REFERENCES \"shared\".\"team_member\"(\"id\")");

        sql.Should().Contain("PRIMARY KEY (\"zoneId\", \"childId\")");
        sql.Should().Contain("PRIMARY KEY (\"departmentId\", \"employeeId\")");
        sql.Should().Contain("PRIMARY KEY (\"projectId\", \"taskId\")");
        sql.Should().Contain("PRIMARY KEY (\"projectId\", \"team_memberId\")");

        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_zone_zone_zoneId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_zone_zone_childId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_department_employee_departmentId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_department_employee_employeeId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_project_task_projectId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_project_task_taskId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_project_team_member_projectId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_project_team_member_team_memberId\"");

        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"employee_role\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"task_status\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"task_priority\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"shared\".\"team_role\"");

        sql.Should().Contain("ALTER TABLE \"shared\".\"employee\" ADD CONSTRAINT \"fk_employee_role\"");
        sql.Should().Contain("ALTER TABLE \"shared\".\"task\" ADD CONSTRAINT \"fk_task_status\"");
        sql.Should().Contain("ALTER TABLE \"shared\".\"task\" ADD CONSTRAINT \"fk_task_priority\"");
        sql.Should().Contain("ALTER TABLE \"shared\".\"team_member\" ADD CONSTRAINT \"fk_team_member_role\"");
    }

    private class NoTable
    {
        public int Id { get; set; }
    }
}
