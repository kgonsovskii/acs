using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Logic.Api;
using SevenSeals.Tss.Shared;
using SevenSeals.Tss.Shared.Tests.Base;

namespace SevenSeals.Tss.Logic;

[TestClass]
public class CallbackTest: TestBase<ILogicCallbackClient, LogicTestFactory, Startup>
{
    [TestMethod]
    public async Task CallBack()
    {
        var client = OpenClient();
        await client.OnContourCallBack(new CallBackRequest());
    }
}
