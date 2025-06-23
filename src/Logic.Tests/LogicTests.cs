using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared.Tests.Base;

namespace SevenSeals.Tss.Logic;

[TestClass]
public class LogicTests: TestBase<ILogicClient, LogicTestFactory, Startup>
{
    [TestMethod]
    public async Task State()
    {
        await Task.Delay(0);
    }
}
