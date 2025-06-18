using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

[TestClass]
public class ActorTests : TestStorageBase<Actor, Actor, Guid, IActorClient, ActorTestFactory, Startup>
{
    protected override Guid GetId(Actor response)
    {
        return response.Id;
    }

    protected override Actor CreateRequest()
    {
        return new Actor() { Card = new Person() };
    }
}
