using Infra;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SevenSeals.Tss.Infra.Tests;

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
            InfraEnvironment.SkipIfNotCi("This test requires CI environment");
            Assert.IsTrue("Local" == InfraEnvironment.GetCiProvider());
        }
        catch
        {
            Assert.IsFalse(InfraEnvironment.IsRunningInCi);
        }
    }

    [TestMethod]
    public void TestThatOnlyRunsLocally()
    {
        try
        {
            InfraEnvironment.SkipIfCi("This test should only run locally!");
            Assert.IsTrue(InfraEnvironment.IsRunningInCi);
        }
        catch (Exception e)
        {
            Assert.IsTrue("Local" == InfraEnvironment.GetCiProvider());
        }
    }

    [TestMethod]
    public void TestWithConditionalLogic()
    {
        if (InfraEnvironment.IsRunningInCi)
        {
            var provider = InfraEnvironment.GetCiProvider();
            Assert.IsTrue(new[] { "GitHub Actions", "GitLab CI", "GitVerse CI", "Unknown CI" }.Contains(provider));
        }
        else
        {
            Assert.IsTrue("Local" == InfraEnvironment.GetCiProvider());
        }
    }
}
