using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Contour;
using Snapshot;

namespace Contour.Tests;

[TestClass]
public class SnapshotTest: ContourTestsBase<SnapshotClient>
{
    [TestMethod] public async Task State()
    {
        using var client = OpenClient();
        var request = NewBaseRequest<StateRequest>();

        var response = await client.State(request);
        response.State.Should().NotBeNull();
    }

    [TestMethod] public async Task Events()
    {
        using var client = OpenClient();
        var request = NewBaseRequest<EventsRequest>();

        var response = await client.Events(request);
        response.Events.Should().NotBeNull();
    }
}
