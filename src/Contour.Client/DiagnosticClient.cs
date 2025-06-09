using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Contour.Diagnostic;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public class DiagnosticClient: ContourBaseClient
{
    public DiagnosticClient(HttpClient httpClient, Settings settings, IOptions<ContourClientOptions> options, ILogger<ContourBaseClient> logger) : base(httpClient, settings, options, logger)
    {
    }

    public async Task<ValueResponse> ProgId(SpotRequest request)
        => await PostAsync<SpotRequest, ValueResponse>(nameof(ProgId), request);

    public async Task<ValueResponse> ProgVer(SpotRequest request)
        => await PostAsync<SpotRequest, ValueResponse>(nameof(ProgVer), request);

    public async Task<ValueResponse> SerNum(SpotRequest request)
        => await PostAsync<SpotRequest, ValueResponse>(nameof(SerNum), request);
}
