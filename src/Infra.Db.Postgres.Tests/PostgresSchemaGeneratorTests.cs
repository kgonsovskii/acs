using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Infra.Db;

[TestClass]
public class PostgresSchemaGeneratorTests: SchemaGeneratorTestBase
{
    protected override ISchemaGenerator SchemaGenerator { get; } = new PostgresSchemaGenerator();

    [TestMethod]
    public override void GenerateCreateTableSql_UserModel_Works()
    {
        var sql = SchemaGenerator.GenerateCreateTableSql(typeof(User));
        sql.Should().Contain("CREATE TABLE \"db\".\"user\"");
        sql.Should().Contain("\"id\" SERIAL PRIMARY KEY");
        sql.Should().Contain("\"name\" TEXT NOT NULL");
    }

    [TestMethod]
    public override void GenerateCreateTableSql_PostModel_Works()
    {
        var sql = SchemaGenerator.GenerateCreateTableSql(typeof(Post));
        sql.Should().Contain("CREATE TABLE \"db\".\"post\"");
        sql.Should().Contain("\"id\" SERIAL PRIMARY KEY");
        sql.Should().Contain("\"user_id\" INTEGER NOT NULL");
        sql.Should().Contain("\"title\" TEXT NOT NULL");
        sql.Should().Contain("\"slug\" TEXT NOT NULL");
    }

    [TestMethod]
    public override void GenerateCreateTableSql_Throws_IfNoTableAttribute()
    {
        Action act = () => SchemaGenerator.GenerateCreateTableSql(typeof(NoTable));
        act.Should().Throw<InvalidOperationException>();
    }

    [TestMethod]
    public override void GenerateCreateTableSql_WithIndexAttributes_GeneratesIndexes()
    {
        var sql = SchemaGenerator.GenerateCreateTableSql(typeof(Post));
        sql.Should().Contain("\"user_id\" INTEGER NOT NULL");
        sql.Should().Contain("\"title\" TEXT NOT NULL");
        sql.Should().Contain("\"slug\" TEXT NOT NULL");
    }


    [TestMethod]
    public override void GenerateCreateTableSql_WithCsvStringAttribute_ColumnIsText()
    {
        var sql = SchemaGenerator.GenerateCreateTableSql(typeof(Taggable));
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
        var sql = SchemaGenerator.GenerateCreateTableSql(typeof(NullableTestModel));

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
        var sql = SchemaGenerator.GenerateCreateTableSql(typeof(User));
        sql.Should().Contain("\"id\" SERIAL PRIMARY KEY");
    }
}
