using FluentAssertions;
using Infra;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

[TestClass]
public class GeneralTests
{
    [TestMethod]
    public void TestMachineCodeGenerator()
    {
        var code = MachineCode.GetMachineCode();
        code.Should().NotBeNullOrEmpty();
    }
}
