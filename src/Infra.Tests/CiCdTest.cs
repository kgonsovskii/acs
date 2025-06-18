using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared;

namespace Infra.Db;

[TestClass]
public class CiCdTest
{
    [TestMethod]
    public void TestThatRunsEverywhere()
    {
        Assert.IsTrue(true);
    }

    [TestMethod]
    public void TestThatOnlyRunsInCI()
    {
        try
        {
            TestEnvironment.SkipIfNotCi("This test requires CI environment");
            Assert.IsTrue("Local" == TestEnvironment.GetCiProvider());
        }
        catch
        {
            Assert.IsFalse(TestEnvironment.IsRunningInCi);
        }
    }

    [TestMethod]
    public void TestThatOnlyRunsLocally()
    {
        try
        {
            TestEnvironment.SkipIfCi("This test should only run locally!");
            Assert.IsTrue(TestEnvironment.IsRunningInCi);
        }
        catch (Exception e)
        {
            Assert.IsTrue("Local" == TestEnvironment.GetCiProvider());
        }
    }

    [TestMethod]
    public void TestWithConditionalLogic()
    {
        if (TestEnvironment.IsRunningInCi)
        {
            var provider = TestEnvironment.GetCiProvider();
            Assert.IsTrue(new[] { "GitHub Actions", "GitLab CI", "GitVerse CI", "Unknown CI" }.Contains(provider));
        }
        else
        {
            Assert.IsTrue("Local" == TestEnvironment.GetCiProvider());
        }
    }
}
