using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Contour.Events;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

[TestClass]
public class ContourEventSerializationTests
{
    [TestMethod]
    public void ContourEvent_SerializeDeserialize_Works()
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
        var json = keyEvent.Serialize();
        var deserialized = json.Deserialize<ContourKeyEvent>();
        deserialized.Should().NotBeNull();
        deserialized!.SpotId.Should().Be(keyEvent.SpotId);
        deserialized.KeyNumber.Should().Be(keyEvent.KeyNumber);
        deserialized.Kind.Should().Be(keyEvent.Kind);
    }

    [TestMethod]
    public void ContourEvent_Base_SerializeDeserialize_Works()
    {
        var eventData = new byte[16];
        eventData[1] = 0x04; // Button event
        var buttonEvent = new ContourButtonEvent("test-channel", eventData)
        {
            SpotId = Guid.NewGuid()
        };
        var json = buttonEvent.Serialize();
        var deserialized = json.Deserialize<ContourButtonEvent>();
        deserialized.Should().NotBeNull();
        deserialized!.SpotId.Should().Be(buttonEvent.SpotId);
        deserialized.Kind.Should().Be(buttonEvent.Kind);
    }

    [TestMethod]
    public void ContourEvent_Base_SerializeDeserialize_Work2()
    {
        var eventData = new byte[16];
        eventData[1] = 0x04; // Button event
        var buttonEvent = new ContourDoorOpenEvent("test-channel", eventData)
        {
            SpotId = Guid.NewGuid()
        };
        var json = buttonEvent.Serialize();
        var deserialized = json.Deserialize<ContourDoorOpenEvent>();
        deserialized.Should().NotBeNull();
        deserialized!.SpotId.Should().Be(buttonEvent.SpotId);
        deserialized.Kind.Should().Be(buttonEvent.Kind);
    }
}
