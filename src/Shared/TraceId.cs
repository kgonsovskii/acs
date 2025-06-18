namespace SevenSeals.Tss.Shared;

public static class TraceId
{
    private static volatile int _traceId = 0;
    public static int NextTraceId() => Interlocked.Increment(ref _traceId);
}
