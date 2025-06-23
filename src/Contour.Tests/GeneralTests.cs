using FluentAssertions;
using Infra;
using Microsoft.VisualStudio.TestTools.UnitTesting;

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
