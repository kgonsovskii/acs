using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Contour.Diagnostic;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public interface IDiagnosticClient : IProtoClient
{
    public Task<ValueResponse> ProgId(SpotRequest request);

    public Task<ValueResponse> ProgVer(SpotRequest request);

    public Task<ValueResponse> SerNum(SpotRequest request);
}
public class DiagnosticClient: ProtoClient, IDiagnosticClient
{
    public DiagnosticClient(HttpClient httpClient, Settings settings, IOptions<ContourClientOptions> options, ILogger<DiagnosticClient> logger) : base(httpClient, settings, options, logger)
    {
    }

    public async Task<ValueResponse> ProgId(SpotRequest request)
        => await PostAsync<SpotRequest, ValueResponse>(nameof(ProgId), request);

    public async Task<ValueResponse> ProgVer(SpotRequest request)
        => await PostAsync<SpotRequest, ValueResponse>(nameof(ProgVer), request);

    public async Task<ValueResponse> SerNum(SpotRequest request)
        => await PostAsync<SpotRequest, ValueResponse>(nameof(SerNum), request);
}
