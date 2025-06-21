using System.IO.Ports;
using FluentAssertions;
using Infra;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

[TestClass]
public class SpotTests : TestStorageBase<Spot, Spot, Guid, ISpotClient, ContourTestFactory, Startup>
{
    protected override Guid GetId(Spot response)
    {
        return response.Id;
    }

    protected override Spot CreateRequest()
    {
        var spot = new Spot()
        {
            Addresses = ["1", "2", "3"],
            Hint = "Some Hint",
            Options = new ComPortOptions()
            {
                PortName = "COM3",
                BaudRate = 1, DataBits = 2, Parity = Parity.Even, ReadTimeoutMs = 3, WriteTimeoutMs = 4,
            },
        };
        return spot;
    }

    [TestMethod]
    public async Task TestSmart()
    {
        using var client = OpenClient();
        var request = CreateRequest();
        var response = await client.Add(request);
        var restored = await client.GetById(response.Id);
        var result = restored.IsSimilar(request, out var strings);
        result.Should().BeTrue(strings);

        var restoredAll = await client.GetAll();
        restored = restoredAll.First(a=> a.Id == response.Id);
        result = restored.IsSimilar(request, out strings);
        result.Should().BeTrue(strings);
    }
}
