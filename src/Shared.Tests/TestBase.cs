using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Shared.Tests;

public abstract class TestBase
{
protected void Log(string message)
    {
        TestContext.WriteLine(message);
    }
#pragma warning disable CS8618 // Non-nullable field must contain a non-null value when exiting constructor. Consider adding the 'required' modifier or declaring as nullable.
    public TestContext TestContext { get; set; }
#pragma warning restore CS8618 // Non-nullable field must contain a non-null value when exiting constructor. Consider adding the 'required' modifier or declaring as nullable.
}
