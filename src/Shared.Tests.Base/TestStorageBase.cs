using System.Diagnostics;
using FluentAssertions;
using Infra;
using Microsoft.VisualStudio.TestTools.UnitTesting;

#pragma warning disable CS8618 // Non-nullable field must contain a non-null value when exiting constructor. Consider adding the 'required' modifier or declaring as nullable.

namespace SevenSeals.Tss.Shared.Tests.Base;

public abstract class TestStorageBase<TRequest, TResponse, TId, TClient, TFactory, TStartup> : TestBase<TClient, TFactory, TStartup>

    where TClient: IProtoStorageClient<TRequest, TResponse, TId>
    where TFactory: TestWebAppFactory<TStartup>, new()
    where TStartup: class
    where TRequest: IProtoRequest
    where TResponse: IProtoResponse
{
    protected virtual TRequest CreateRequest()
    {
        var request = Activator.CreateInstance(typeof(TRequest));
        request.FillWithRandomValues();
        return ((TRequest)request!)!;
    }

    protected abstract TId GetId(TResponse response);

    [TestMethod]
    public async Task GetAll()
    {
        using var client = OpenClient();
        var request = CreateRequest();
        var response = await client.Add(request);
        var id = GetId(response);

        var all = await client.GetAll();
        var added = all.FirstOrDefault(a => GetId(a)!.Equals(id))!;
        GetId(added).Should().Be(id);
    }

    [TestMethod]
    public virtual async Task AddAndGetById()
    {
        using var client = OpenClient();
        var request = CreateRequest();
        var response = await client.Add(request);
        var id = GetId(response);
        Debug.Assert(id != null, nameof(id) + " != null");
        id.ToString().Should().NotBeNull();
    }

    [TestMethod]
    public virtual async Task Update()
    {
        using var client = OpenClient();
        var request = CreateRequest();
        var response = await client.Add(request);
        var id = GetId(response);
        var updateResponse = await client.Update(id, request);
        updateResponse.Should().NotBeNull();
        var id2 = GetId(updateResponse);
        id2.Should().Be(id);
    }

    [TestMethod]
    public virtual async Task Delete()
    {
        using var client = OpenClient();
        var request = CreateRequest();
        var response = await client.Add(request);
        var id = GetId(response);
        await client.Delete(id);
    }

    [TestMethod]
    public virtual async Task GetByField()
    {
        using var client = OpenClient();
        var request = CreateRequest();
        var response = await client.Add(request);
        var id = GetId(response);

        // Test getting by ID field
        var results = await client.GetByField("Id", id);
        results.Should().NotBeEmpty();
        results.First().Should().NotBeNull();
    }

    [TestMethod]
    public virtual async Task GetByFields()
    {
        using var client = OpenClient();
        var request = CreateRequest();
        var response = await client.Add(request);
        var id = GetId(response);

        var criteria = new Dictionary<string, object>
        {
            { "Id", id }
        };

        var results = await client.GetByFields(criteria);
        results.Should().NotBeEmpty();
        results.First().Should().NotBeNull();
    }

    [TestMethod]
    public virtual async Task GetByWhere()
    {
        using var client = OpenClient();
        var request = CreateRequest();
        var response = await client.Add(request);
        var id = GetId(response);

        var whereRequest = new WhereRequest
        {
            WhereClause = "Id = @id",
            Parameters = new Dictionary<string, object>
            {
                { "id", id }
            }
        };

        var results = await client.GetByWhere(whereRequest);
        results.Should().NotBeEmpty();
        results.First().Should().NotBeNull();
    }

    [TestMethod]
    public virtual async Task GetFirstByField()
    {
        using var client = OpenClient();
        var request = CreateRequest();
        var response = await client.Add(request);
        var id = GetId(response);

        var result = await client.GetFirstByField("Id", id);
        result.Should().NotBeNull();
        GetId(result).Should().Be(id);
    }

    [TestMethod]
    public virtual async Task ExistsByField()
    {
        using var client = OpenClient();
        var request = CreateRequest();
        var response = await client.Add(request);
        var id = GetId(response);

        var exists = await client.ExistsByField("Id", id);
        exists.Should().BeTrue();

        var notExists = await client.ExistsByField("Id", Guid.NewGuid());
        notExists.Should().BeFalse();
    }
}
