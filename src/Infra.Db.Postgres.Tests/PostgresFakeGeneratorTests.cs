using Infra.Db;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SevenSeals.Tss.Infra.Db.Postgres.Tests;

[TestClass]
public class PostgresFakeGeneratorTests
{
    [TestMethod]
    public void GenerateFakeDataSqlForTypes_GeneratesSql()
    {
        var fakeGen = new PostgresFakeGenerator();
        var sql = fakeGen.GenerateFakeDataSqlForTypes(new List<Type>()); // TODO: Add real types
        Assert.IsNotNull(sql);
    }
} 