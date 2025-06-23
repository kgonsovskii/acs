using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Contour.Events;

namespace SevenSeals.Tss.Contour;

[TestClass]
public class ContourTests: ContourTestsBase<IContourClient>
{
    [TestMethod] public async Task Link()
    {
        using var client = OpenClient();
        var request = NewRequest<ContourRequest>();

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

    [TestMethod] public async Task State()
    {
        using var client = OpenClient();
        var request = NewBaseRequest<StateRequest>();

        var state = await client.State(request);
        state.Should().NotBeNull();
    }

    [DataTestMethod] [DataRow(1, 3)] public async Task RelayOnComPort(int port, int interval)
    {
        using var client = OpenClient();
        var request = NewRequestComPort<RelayOnRequest>();
        request.RelayPort = port;
        request.Interval = interval;

        _ = await client.RelayOn(request);
    }

    [TestMethod] public void ControllerKeyEvent_KeyHexString_ShouldMatchLegacyFormat()
    {
        var eventData = new byte[16];
        eventData[2] = 0x89;
        eventData[3] = 0x1B;
        eventData[4] = 0x7B;
        eventData[5] = 0x00;
        eventData[6] = 0x00;
        eventData[7] = 0x00;

        var keyEvent = new ContourKeyEvent("test-channel", eventData)
        {
            SpotId = Guid.NewGuid()
        };
        keyEvent.KeyNumber.Should().Be("0000007B1B89");
    }


}
