using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Infra.Db;

[TestClass]
public class PostgresDatabaseGeneratorTests: DatabaseGeneratorTestBase
{
    protected override IDatabaseGenerator DatabaseGenerator { get; } = new PostgresDatabaseGenerator(new PostgresSchemaGenerator());

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
        sql.Should().Contain("\"poly_modelId\" UUID REFERENCES \"db\".\"poly_model\"(\"id\")");
        sql.Should().Contain("\"ip_address\" TEXT");
        sql.Should().Contain("\"port\" INTEGER");
        sql.Should().Contain("CREATE TABLE IF NOT EXISTS \"db\".\"poly_model_com_port\"");
        sql.Should().Contain("\"poly_modelId\" UUID REFERENCES \"db\".\"poly_model\"(\"id\")");
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
        var sql = new PostgresDatabaseGenerator(new PostgresSchemaGenerator()).GenerateDatabaseSqlForTypes([typeof(Key), typeof(Actor)]);

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

        sql.Should().Contain("\"zoneId\" UUID REFERENCES \"db\".\"zone\"(\"id\")");
        sql.Should().Contain("\"childId\" UUID REFERENCES \"db\".\"zone\"(\"id\")");
        sql.Should().Contain("\"departmentId\" UUID REFERENCES \"db\".\"department\"(\"id\")");
        sql.Should().Contain("\"employeeId\" UUID REFERENCES \"db\".\"employee\"(\"id\")");
        sql.Should().Contain("\"projectId\" UUID REFERENCES \"db\".\"project\"(\"id\")");
        sql.Should().Contain("\"zenaId\" UUID REFERENCES \"db\".\"zena\"(\"id\")");
        sql.Should().Contain("\"projectId\" UUID REFERENCES \"db\".\"project\"(\"id\")");
        sql.Should().Contain("\"team_memberId\" UUID REFERENCES \"db\".\"team_member\"(\"id\")");

        sql.Should().Contain("PRIMARY KEY (\"zoneId\", \"childId\")");
        sql.Should().Contain("PRIMARY KEY (\"departmentId\", \"employeeId\")");
        sql.Should().Contain("PRIMARY KEY (\"projectId\", \"zenaId\")");
        sql.Should().Contain("PRIMARY KEY (\"projectId\", \"team_memberId\")");

        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_zone_child_zoneId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_zone_child_childId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_department_employee_departmentId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_department_employee_employeeId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_project_zena_projectId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_project_zena_zenaId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_project_team_member_projectId\"");
        sql.Should().Contain("CREATE INDEX IF NOT EXISTS \"idx_project_team_member_team_memberId\"");

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
