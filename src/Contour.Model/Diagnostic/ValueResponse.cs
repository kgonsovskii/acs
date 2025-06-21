using SevenSeals.Tss.Contour.Api;

namespace SevenSeals.Tss.Contour.Diagnostic;

public class ValueResponse: SpotResponse
{
    public string Name { get; set; } = string.Empty;
    public string Value { get; set; }= string.Empty;
}
