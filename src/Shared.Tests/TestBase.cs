using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Shared.Tests;

public abstract class TestBase
{
    protected void Log(string message)
    {
        TestContext.WriteLine(message);
    }
    public TestContext TestContext { get; set; }
}
