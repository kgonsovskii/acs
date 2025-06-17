using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SevenSeals.Tss.Contour;

[TestClass]
public class ContourTests: ContourTestsBase<IContourClient>
{
    [TestMethod] public async Task Link()
    {
        using var client = OpenClient();
        var request = NewRequest<SpotRequest>();

        var response = await client.Link(request);
        response.SessionId.Should().NotBeNull();
    }

    [DataTestMethod] [DataRow(1, 3)] public async Task RelayOn(int port, int interval)
    {
        using var client = OpenClient();
        var request = NewRequest<RelayOnRequest>();
        request.RelayPort = port;
        request.Interval = interval;

        _ = await client.RelayOn(request);
    }

    [DataTestMethod] [DataRow(1)] public async Task RelayOff(int port)
    {
        using var client = OpenClient();
        var request = NewRequest<RelayOffRequest>();
        request.RelayPort = port;

        _ = await client.RelayOff(request);
    }

    [DataTestMethod] [DataRow(1, 3)] public async Task RelayOnComPort(int port, int interval)
    {
        using var client = OpenClient();
        var request = NewRequestComPort<RelayOnRequest>();
        request.RelayPort = port;
        request.Interval = interval;

        _ = await client.RelayOn(request);
    }

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
