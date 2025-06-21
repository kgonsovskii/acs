using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Infra.Db;

[TestClass]
public class PostgresDatabaseGeneratorTests: DatabaseGeneratorTestBase
{
    protected override IDatabaseGenerator DatabaseGenerator { get; } = new PostgresDatabaseGenerator();


    [TestMethod]
    public override void GenerateCreateTableSql_UserModel_Works()
    {
        var sql = DatabaseGenerator.GenerateCreateTableSql(typeof(User));
        sql.Should().Contain("CREATE TABLE \"db\".\"user\"");
        sql.Should().Contain("\"id\" SERIAL PRIMARY KEY");
        sql.Should().Contain("\"name\" TEXT NOT NULL");
    }

    [TestMethod]
    public override void GenerateCreateTableSql_PostModel_Works()
    {
        var sql = DatabaseGenerator.GenerateCreateTableSql(typeof(Post));
        sql.Should().Contain("CREATE TABLE \"db\".\"post\"");
        sql.Should().Contain("\"id\" SERIAL PRIMARY KEY");
        sql.Should().Contain("\"user_id\" INTEGER NOT NULL");
        sql.Should().Contain("\"title\" TEXT NOT NULL");
        sql.Should().Contain("\"slug\" TEXT NOT NULL");
    }

    [TestMethod]
    public override void GenerateCreateTableSql_Throws_IfNoTableAttribute()
    {
        Action act = () => DatabaseGenerator.GenerateCreateTableSql(typeof(NoTable));
        act.Should().Throw<InvalidOperationException>();
    }

    [TestMethod]
    public override void GenerateCreateTableSql_WithIndexAttributes_GeneratesIndexes()
    {
        var sql = DatabaseGenerator.GenerateCreateTableSql(typeof(Post));
        sql.Should().Contain("\"user_id\" INTEGER NOT NULL");
        sql.Should().Contain("\"title\" TEXT NOT NULL");
        sql.Should().Contain("\"slug\" TEXT NOT NULL");
    }


    [TestMethod]
    public override void GenerateCreateTableSql_WithCsvStringAttribute_ColumnIsText()
    {
        var sql = DatabaseGenerator.GenerateCreateTableSql(typeof(Taggable));
        sql.Should().Contain("\"tags\" TEXT");
        sql.Should().Contain("\"labels\" TEXT");
    }

    [TestMethod]
    public override void CsvString_Serialization_Works()
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
    public override void SchemaGenerator_HandlesNullableTypes()
    {
        var sql = DatabaseGenerator.GenerateCreateTableSql(typeof(NullableTestModel));

        sql.Should().Contain("\"nullable_string\" TEXT NULL");
        sql.Should().Contain("\"required_string\" TEXT NOT NULL");

        sql.Should().Contain("\"nullable_int\" INTEGER NULL");
        sql.Should().Contain("\"required_int\" INTEGER NOT NULL");

        sql.Should().Contain("\"nullable_long\" BIGINT NULL");
        sql.Should().Contain("\"required_long\" BIGINT NOT NULL");

        sql.Should().Contain("\"nullable_date_time\" TIMESTAMP NULL");
        sql.Should().Contain("\"required_date_time\" TIMESTAMP NOT NULL");

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
    public override void SchemaGenerator_HandlesPrimaryKeyWithNullableType()
    {
        var sql = DatabaseGenerator.GenerateCreateTableSql(typeof(User));
        sql.Should().Contain("\"id\" SERIAL PRIMARY KEY");
    }

    [TestMethod]
    public override void DatabaseGenerator_GeneratesIndexes()
    {
        var sql = DatabaseGenerator.GenerateDatabaseSqlForTypes([typeof(Post), typeof(User), typeof(Activity)]);
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_post_user_id\" ON \"db\".\"post\"(\"user_id\")");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_title\" ON \"db\".\"post\"(\"title\")");
        sql.Should().Contain("CREATE UNIQUE INDEX IF NOT EXISTS \"idx_post_slug\" ON \"db\".\"post\"(\"slug\")");
        sql.Should().Contain("CREATE UNIQUE INDEX IF NOT EXISTS \"idx_post_user_id_title\" ON \"db\".\"post\"(\"user_id\", \"title\")");
        sql.Should().Contain("CREATE UNIQUE INDEX IF NOT EXISTS \"idx_user_name\" ON \"db\".\"user\"(\"name\")");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_activity_user_id\" ON \"db\".\"activity\"(\"user_id\")");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_activity_timestamp\" ON \"db\".\"activity\"(\"timestamp\")");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_activity_user_id_timestamp\" ON \"db\".\"activity\"(\"user_id\", \"timestamp\")");
    }

    [TestMethod]
    public override void DatabaseGenerator_GeneratesPolymorphicTables()
    {
        var sql = DatabaseGenerator.GenerateDatabaseSqlForTypes([typeof(PolyModel)]);
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"poly_model_ip\"");
        sql.Should().Contain("\"poly_model_id\" UUID REFERENCES \"db\".\"poly_model\"(\"id\")");
        sql.Should().Contain("\"ip_address\" TEXT");
        sql.Should().Contain("\"port\" INTEGER");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"poly_model_com_port\"");
        sql.Should().Contain("\"poly_model_id\" UUID REFERENCES \"db\".\"poly_model\"(\"id\")");
        sql.Should().Contain("\"port_name\" TEXT");
        sql.Should().Contain("\"baud_rate\" INTEGER");
    }

    [TestMethod]
    public override void DatabaseGenerator_GeneratesEnumTables()
    {
        var sql = DatabaseGenerator.GenerateDatabaseSqlForTypes([typeof(Key), typeof(Actor)]);

        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"key_type\" (");
        sql.Should().Contain("\"name\" TEXT PRIMARY KEY");
        sql.Should().Contain("\"description\" TEXT");

        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"key_status\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"actor_types\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"storage_types\"");
    }

    [TestMethod]
    public override void DatabaseGenerator_PopulatesEnumData()
    {
        var sql = DatabaseGenerator.GenerateDatabaseSqlForTypes([typeof(Key), typeof(Actor)]);

        sql.Should().Contain("INSERT INTO \"db\".\"key_type\" (\"name\", \"description\") VALUES ('physical', 'Physical')");
        sql.Should().Contain("INSERT INTO \"db\".\"key_type\" (\"name\", \"description\") VALUES ('virtual', 'Virtual')");
        sql.Should().Contain("INSERT INTO \"db\".\"key_type\" (\"name\", \"description\") VALUES ('card', 'Card')");
        sql.Should().Contain("INSERT INTO \"db\".\"key_type\" (\"name\", \"description\") VALUES ('mobile', 'Mobile')");

        sql.Should().Contain("INSERT INTO \"db\".\"key_status\" (\"name\", \"description\") VALUES ('active', 'Active')");
        sql.Should().Contain("INSERT INTO \"db\".\"key_status\" (\"name\", \"description\") VALUES ('lost', 'Lost')");

        sql.Should().Contain("INSERT INTO \"db\".\"actor_types\" (\"name\", \"description\") VALUES ('person', 'Person')");
        sql.Should().Contain("INSERT INTO \"db\".\"actor_types\" (\"name\", \"description\") VALUES ('drone', 'Drone')");
    }

    [TestMethod]
    public override void DatabaseGenerator_CreatesEnumForeignKeys()
    {
        var sql = DatabaseGenerator.GenerateDatabaseSqlForTypes([typeof(Key), typeof(Actor)]);

        sql.Should().Contain("ALTER TABLE \"db\".\"key\" ADD CONSTRAINT \"fk_key_type\" FOREIGN KEY (\"type\") REFERENCES \"db\".\"key_type\"(\"name\");");
        sql.Should().Contain("ALTER TABLE \"db\".\"key\" ADD CONSTRAINT \"fk_key_status\" FOREIGN KEY (\"status\") REFERENCES \"db\".\"key_status\"(\"name\");");
        sql.Should().Contain("ALTER TABLE \"db\".\"actor\" ADD CONSTRAINT \"fk_actor_type\" FOREIGN KEY (\"type\") REFERENCES \"db\".\"actor_types\"(\"name\");");
        sql.Should().Contain("ALTER TABLE \"db\".\"actor\" ADD CONSTRAINT \"fk_actor_preferred_storage\" FOREIGN KEY (\"preferred_storage\") REFERENCES \"db\".\"storage_types\"(\"name\");");
    }

    [TestMethod]
    public override void DatabaseGenerator_HandlesEnumWithoutDescription()
    {
        var sql = DatabaseGenerator.GenerateDatabaseSqlForTypes([typeof(PolyModel)]);

        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"channel_type\"");
        sql.Should().Contain("\"name\" TEXT PRIMARY KEY");
        sql.Should().NotContain("\"description\" TEXT");

        sql.Should().Contain("INSERT INTO \"db\".\"channel_type\" (\"name\") VALUES ('ip')");
        sql.Should().Contain("INSERT INTO \"db\".\"channel_type\" (\"name\") VALUES ('com_port')");
    }

    [TestMethod]
    public override void GenerateDatabaseSql_WithChildTableAttribute_GeneratesJunctionTables()
    {
        var generator = DatabaseGenerator;
        var types = new List<Type> { typeof(Zone), typeof(Department), typeof(Employee), typeof(Project), typeof(Zena), typeof(TeamMember) };

        var sql = generator.GenerateDatabaseSqlForTypes(types);

        sql.Should().Contain("-- Child tables");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"zone_child\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"department_employee\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"project_zena\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"project_team_member\"");

        sql.Should().Contain("\"zone_id\" UUID REFERENCES \"db\".\"zone\"(\"id\")");
        sql.Should().Contain("\"child_id\" UUID REFERENCES \"db\".\"zone\"(\"id\")");
        sql.Should().Contain("\"department_id\" UUID REFERENCES \"db\".\"department\"(\"id\")");
        sql.Should().Contain("\"employee_id\" UUID REFERENCES \"db\".\"employee\"(\"id\")");
        sql.Should().Contain("\"project_id\" UUID REFERENCES \"db\".\"project\"(\"id\")");
        sql.Should().Contain("\"zena_id\" UUID REFERENCES \"db\".\"zena\"(\"id\")");
        sql.Should().Contain("\"project_id\" UUID REFERENCES \"db\".\"project\"(\"id\")");
        sql.Should().Contain("\"team_member_id\" UUID REFERENCES \"db\".\"team_member\"(\"id\")");

        sql.Should().Contain("PRIMARY KEY (\"zone_id\", \"child_id\")");
        sql.Should().Contain("PRIMARY KEY (\"department_id\", \"employee_id\")");
        sql.Should().Contain("PRIMARY KEY (\"project_id\", \"zena_id\")");
        sql.Should().Contain("PRIMARY KEY (\"project_id\", \"team_member_id\")");

        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_zone_child_zone_id\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_zone_child_child_id\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_department_employee_department_id\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_department_employee_employee_id\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_project_zena_project_id\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_project_zena_zena_id\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_project_team_member_project_id\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_project_team_member_team_member_id\"");

        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"employee_role\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"task_status\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"task_priority\"");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"team_role\"");

        sql.Should().Contain("ALTER TABLE \"db\".\"employee\" ADD CONSTRAINT \"fk_employee_role\"");
        sql.Should().Contain("ALTER TABLE \"db\".\"zena\" ADD CONSTRAINT \"fk_zena_status\"");
        sql.Should().Contain("ALTER TABLE \"db\".\"zena\" ADD CONSTRAINT \"fk_zena_priority\"");
        sql.Should().Contain("ALTER TABLE \"db\".\"team_member\" ADD CONSTRAINT \"fk_team_member_role\"");
    }
}
