﻿using Infra;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared.Tests.Base;

namespace SevenSeals.Tss.Actor;

[TestClass]
public class PassTests : TestStorageBase<Pass, Pass, Guid, IPassClient, ActorTestFactory, Startup>
{
    protected override Guid GetId(Pass response)
    {
        return response.Id;
    }

    protected override Pass CreateRequest()
    {
        var pass = new Pass();
        pass.FillWithRandomValues();
        pass.MemberId = null;
        return pass;
    }
}
