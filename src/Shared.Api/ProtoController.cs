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

    protected OkObjectResult OkProto(TRequest request, TResponse response)
    {
        //var newHash = request.GetHash();
        // if (!Settings.IsDevelopment && newHash != request.Hash)
        // {
        //     throw new ApiException($"Invalid request hash on  server side, TraceId: {request.TraceId}");
        // }
        response.Headers.Agent = Settings.Agent;
        response.Headers.TraceId = request.Headers.TraceId;
        response.Headers.TimeStamp = DateTime.UtcNow.Ticks;
        response.Headers.Hash = response.GetProtoHash();
        return base.Ok(response);
    }
}
