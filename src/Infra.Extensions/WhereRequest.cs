namespace Infra;

public class WhereRequest
{
    public string WhereClause { get; set; } = string.Empty;
    public Dictionary<string, object>? Parameters { get; set; }
}
