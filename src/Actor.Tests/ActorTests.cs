using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Shared.Tests;

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
        return new Person();
    }
}
