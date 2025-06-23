using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas.Api;

public class PlotResponse: IProtoResponse
{
    public required string Url {get; set; }

    public required string UrlImage {get; set; }
}
