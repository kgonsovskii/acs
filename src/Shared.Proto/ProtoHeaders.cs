using System.ComponentModel;

namespace SevenSeals.Tss.Shared;

public static class ProtoHeaders
{
    [Description("Forward request to another server")]
    public const string ForwardTo = "X-Forward-To";

    [Description("Trace identifier for correlating requests")]
    public const string TraceId = "X-Trace-Id";

    [Description("Agent with Machine-Code identifier for correlating requests")]
    public const string Agent = "X-Agent";

    [Description("Chop value for request processing")]
    public const string Chop = "X-Chop";

    [Description("Hash value for request validation")]
    public const string Hash = "X-Hash";

    [Description("Application version for diagnostics")]
    public const string Version = "X-Version";
}
