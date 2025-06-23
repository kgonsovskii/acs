using Infra;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared;
using SevenSeals.Tss.Shared.Tests.Base;

namespace SevenSeals.Tss.Actor;

[TestClass]
public class MemberTests : TestStorageBase<Member, Member, Guid, IMemberClient, ActorTestFactory, Startup>
{
    protected override Guid GetId(Member response)
    {
        return response.Id;
    }

    protected override Member CreateRequest()
    {
        var result = new Member() { Data = new Person() };
        result.FillWithRandomValues();
        result.Data.FillWithRandomValues();
        return result;
    }

    [TestMethod]
    public void TestSerialization()
    {
        var x = new Member()
        {
            Data = new Person()
            {
                Email = "PersonA@tss.com"
            },
            Name = "Person A"
        };
        var y = x.Serialize();
    }
}
