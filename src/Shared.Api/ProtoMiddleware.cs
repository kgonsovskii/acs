using System.Text.Json;
using Microsoft.AspNetCore.Http;

namespace SevenSeals.Tss.Shared;

public class ProtoMiddleware
{
    private readonly RequestDelegate _next;

    public ProtoMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        if (context.Request.Headers.TryGetValue(ProtoHeaders.TraceId, out var traceId))
            context.Items[ProtoHeaders.TraceId] = traceId.ToString();
        if (context.Request.Headers.TryGetValue(ProtoHeaders.Agent, out var agent))
            context.Items[ProtoHeaders.Agent] = agent.ToString();
        if (context.Request.Headers.TryGetValue(ProtoHeaders.Chop, out var chop))
            context.Items[ProtoHeaders.Chop] = chop.ToString();
        if (context.Request.Headers.TryGetValue(ProtoHeaders.Hash, out var hash))
            context.Items[ProtoHeaders.Hash] = hash.ToString();

        await _next(context);

        if (context.Response.HasStarted)
            return;

        var response = context.Response;
        if (context.Items.TryGetValue(ProtoHeaders.TraceId, out var responseTraceId))
            response.Headers.Add(ProtoHeaders.TraceId, responseTraceId.ToString());
        if (context.Items.TryGetValue(ProtoHeaders.Agent, out var responseAgent))
            response.Headers.Add(ProtoHeaders.Agent, responseAgent.ToString());
        if (context.Items.TryGetValue(ProtoHeaders.Chop, out var responseChop))
            response.Headers.Add(ProtoHeaders.Chop, responseChop.ToString());
        if (context.Items.TryGetValue(ProtoHeaders.Hash, out var responseHash))
            response.Headers.Add(ProtoHeaders.Hash, responseHash.ToString());
    }
}
