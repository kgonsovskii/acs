using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Shared.Model;
using Shared.Tests;

namespace Contour.Tests;

[TestClass]
public class IntegrationTests: TestBase
{
    private ContourClient ComposeSut()
    {
        var factory = new TestWebAppFactory<Startup>();
        var client = factory.CreateClient();
        var contourClient = new ContourClient(client, Log);
        return contourClient;
    }

    [TestMethod]
    public async Task StatusShouldBeOk()
    {
        using var client = ComposeSut();
        var response = await client.GetStatus(new StatusRequest());
        response.Status.Should().Be("OK");
    }
}
