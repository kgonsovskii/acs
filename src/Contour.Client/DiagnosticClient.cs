using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Contour.Diagnostic;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public interface IDiagnosticClient : IProtoClient
{
    public Task<ValueResponse> ProgId(ContourRequest request);

    public Task<ValueResponse> ProgVer(ContourRequest request);

    public Task<ValueResponse> SerNum(ContourRequest request);
}
public class DiagnosticClient: ProtoClient, IDiagnosticClient
{
    public DiagnosticClient(HttpClient httpClient, Settings settings, IOptions<ContourClientOptions> options, ILogger<DiagnosticClient> logger) : base(httpClient, settings, options, logger)
    {
    }

    public async Task<ValueResponse> ProgId(ContourRequest request)
        => await PostAsync<ContourRequest, ValueResponse>(nameof(ProgId), request);

    public async Task<ValueResponse> ProgVer(ContourRequest request)
        => await PostAsync<ContourRequest, ValueResponse>(nameof(ProgVer), request);

    public async Task<ValueResponse> SerNum(ContourRequest request)
        => await PostAsync<ContourRequest, ValueResponse>(nameof(SerNum), request);
}
