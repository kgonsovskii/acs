using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Collections.Concurrent;

namespace SevenSeals.Tss.Shared;

public interface IProtoStatefulClient : IProtoClient
{
}

public class ProtoStatefulClient: ProtoClient, IProtoStatefulClient
{
    private readonly ConcurrentDictionary<string, string> _selfAddressesByAgent = new();

    public ProtoStatefulClient(HttpClient httpClient, Settings settings, IOptions<ClientOptions> options, ILogger<ProtoClient<ClientOptions>> logger) : base(httpClient, settings, options, logger)
    {
    }

    public ProtoStatefulClient(HttpClient httpClient, string agent, ILogger logger) : base(httpClient, agent, logger)
    {
    }

    public ProtoStatefulClient(string baseUri, string agent, Action<string> logAction) : base(baseUri, agent, logAction)
    {
    }

    public string? GetReconstructedAddress()
    {
        return GetReconstructedAddress(Agent);
    }

    public string? GetReconstructedAddress(string agent)
    {
        return _selfAddressesByAgent.GetValueOrDefault(agent);
    }

    public IEnumerable<string> GetKnownAgents()
    {
        return _selfAddressesByAgent.Keys;
    }

    protected override Dictionary<string, string> BuildHeaders(int traceId)
    {
        var result = base.BuildHeaders(traceId);
        return result;
    }

    protected override async Task<TResponse> HandleResponse<TResponse>(HttpResponseMessage response, int traceId,
        int? hash)
    {
        var result = await base.HandleResponse<TResponse>(response, traceId, hash);
        if (!response.Headers.TryGetValues(ProtoHeaders.SelfAddress, out var selfAddressValues))
            return result;
        if (!response.Headers.TryGetValues(ProtoHeaders.Agent, out var agents))
            return result;

        var selfAddress = (selfAddressValues ?? throw new InvalidOperationException()).FirstOrDefault();
        if (!string.IsNullOrEmpty(selfAddress))
        {
            _selfAddressesByAgent[agents!.First()] = selfAddress;
        }

        return result;
    }
}
