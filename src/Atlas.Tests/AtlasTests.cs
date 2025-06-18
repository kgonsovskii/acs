using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

[TestClass]
public class AtlasTests : TestBase<AtlasClient, AtlasTestFactory, Startup>;
