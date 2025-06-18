using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

[TestClass]
public class KeyTests : TestStorageBase<Key, Key, Guid, IKeyClient, ActorTestFactory, Startup>
{
    protected override Guid GetId(Key response)
    {
        return response.Id;
    }
}
