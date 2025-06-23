using Microsoft.AspNetCore.Mvc;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoController: ProtoController<IProtoRequest, IProtoResponse>
{
    protected ProtoController(Settings settings) : base(settings)
    {
    }
}

[ApiController] [Route("api/[controller]")]
public abstract class ProtoController<TRequest, TResponse>: ControllerBase where TRequest : IProtoRequest where TResponse : IProtoResponse
{
    protected Settings Settings { get; }
    protected  ProtoController(Settings settings)
    {
        Settings = settings;
    }

    protected virtual OkObjectResult OkProto(object response)
    {
        HttpContext.Response.Headers[ProtoHeaders.Agent] = Settings.Agent;
        HttpContext.Response.Headers[ProtoHeaders.TraceId] = HttpContext.Items[ProtoHeaders.TraceId]?.ToString();
        HttpContext.Response.Headers[ProtoHeaders.Version] = AppVersion.Version;
        HttpContext.Response.Headers[ProtoHeaders.Chop] = HttpContext.Items[ProtoHeaders.TraceId]?.ToString();
        HttpContext.Response.Headers[ProtoHeaders.Hash] = "";
        return base.Ok(response);
    }
}
