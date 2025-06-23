using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Contour.Events;

namespace SevenSeals.Tss.Contour;

[TestClass]
public class StateTests : ContourTestsBase<IContourClient>
{

    [TestMethod]
    public async Task State()
    {
        using var client = OpenClient();
        var request = NewBaseRequest<StateRequest>();

        var response = await client.State(request);
        response.State.Should().NotBeNull();
    }

    [TestMethod]
    public void ContourKeyEvent_KeyHexString_ShouldMatchLegacyFormat()
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
            SpotId = default
        };
        keyEvent.KeyNumber.Should().Be("0000007B1B89");
    }
}
