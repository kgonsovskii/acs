using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Contour;
using Spot;

namespace Contour.Tests;

[TestClass]
public class SpotTests: ContourTestsBase<SpotClient>
{
    [TestMethod] public async Task Link()
    {
        using var client = OpenClient();
        var request = NewRequest<RelayOnRequest>();

        var response = await client.Link(request);
        response.SessionId.Should().NotBeNull();
    }

    [DataTestMethod] [DataRow(1, 3)] public async Task RelayOn(int port, int interval)
    {
        using var client = OpenClient();
        var request = NewRequest<RelayOnRequest>();
        request.SportPort = port;
        request.Interval = interval;

        _ = await client.RelayOn(request);
    }

    [DataTestMethod] [DataRow(1)] public async Task RelayOff(int port)
    {
        using var client = OpenClient();
        var request = NewRequest<RelayOffRequest>();
        request.SportPort = port;

        _ = await client.RelayOff(request);
    }
}
