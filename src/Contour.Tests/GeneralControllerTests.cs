using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Shared.Model;
using Shared.Tests;

namespace Contour.Tests;

[TestClass]
public class IntegrationTests: TestBase
{
    private TestSettings _settings;
    private ContourClient ComposeSut()
    {
        var factory = new TestWebAppFactory<Startup>();
        var client = factory.CreateClient();
        _settings = factory.Services.GetRequiredService<IOptions<TestSettings>>().Value;
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

    [TestMethod]
    public async Task ItShouldLinkToSpotByHostAndPort()
    {
        using var client = ComposeSut();
        var response = await client.Link(new SpotRequest()
        {
            Host = _settings.TestHost,
            Port = _settings.TestPort,
            Address = _settings.TestAddress,
        });
        response.SessionId.Should().Be("0");
    }
}
