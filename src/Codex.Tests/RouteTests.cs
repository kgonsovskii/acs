using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Codex;

[TestClass]
public class RouteTests : TestStorageBase<RouteRule, RouteRule, Guid, IRouteClient, CodexTestFactory, Startup>
{
    protected override Guid GetId(RouteRule response)
    {
        return response.Id;
    }
}
