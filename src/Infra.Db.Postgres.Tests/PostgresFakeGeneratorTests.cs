using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Infra.Db;

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