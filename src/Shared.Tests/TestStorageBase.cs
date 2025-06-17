using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SevenSeals.Tss.Shared;
#pragma warning disable CS8618 // Non-nullable field must contain a non-null value when exiting constructor. Consider adding the 'required' modifier or declaring as nullable.

namespace Shared.Tests;

public abstract class TestStorageBase<TRequest, TResponse, TId, TClient, TFactory, TStartup> : TestBase<TClient, TFactory, TStartup>

    where TClient: ProtoStorageClient<TRequest, TResponse, TId>
    where TFactory: TestWebAppFactory<TStartup>, new()
    where TStartup: class
    where TRequest: IProtoRequest, new()
    where TResponse: IProtoResponse
{
    protected TRequest CreateRequest()
    {
        var request = new TRequest();
        request.FillWithRandomValues();
        return request;
    }

    protected abstract TId GetId(TResponse response);

    [TestMethod]
    public async Task GetAll()
    {

    }

    [TestMethod]
    public virtual async Task AddAndGetById()
    {
        using var client = OpenClient();
        var request = CreateRequest();
        var response = await client.Add(request);
        var id = GetId(response);
        id.ToString().Should().NotBeNull();
    }

    [TestMethod]
    public virtual async Task Update()
    {
        using var client = OpenClient();
        var request = CreateRequest();
       // var response = await client.Add(request);
        //var id = GetId(response);
        var id = HashExtensions.NewId<TId>("63655943-a024-4488-85a9-b12ddd64fc5a");
        var updateResponse = await client.Update(id, request);
        updateResponse.Should().NotBeNull();
        var id2 = GetId(updateResponse);
        id2.Should().Be(id);
    }

    [TestMethod]
    public virtual async Task Delete()
    {
    }
}
