using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Contour;

namespace Contour.Tests;

[TestClass]
public class DiagnosticTests: ContourTestsBase<DiagnosticClient>
{
    [TestMethod] public async Task ProgId()
    {
        using var client = OpenClient();
        var request = NewRequest<SpotRequest>();

        var response = await client.ProgId(request);
        response.Value.Should().Be("156");
    }

    [TestMethod] public async Task ProgVer()
    {
        using var client = OpenClient();
        var request = NewRequest<SpotRequest>();

        var response = await client.ProgVer(request);
        response.Value.Should().Be("939");
    }

    [TestMethod] public async Task SerNum()
    {
        using var client = OpenClient();
        var request = NewRequest<SpotRequest>();

        var response = await client.SerNum(request);
        response.Value.Should().Be("716703147");
    }
}
