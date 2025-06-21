using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared;

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
        return new Member() { Card = new Person() };
    }
}
