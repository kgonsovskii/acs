using Microsoft.AspNetCore.Mvc;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoController: ProtoController<RequestBase, ResponseBase>
{
    protected ProtoController(Settings settings) : base(settings)
    {
    }
}

[ApiController][Route("api/[controller]")]
public abstract class ProtoController<TRequest, TResponse>: ControllerBase where TRequest : RequestBase where TResponse : ResponseBase
{
    protected Settings Settings { get; }
    protected  ProtoController(Settings settings)
    {
        Settings = settings;
    }

    protected virtual OkObjectResult Ok(TRequest request, TResponse response)
    {
        return OkBase(request, response);
    }

    protected OkObjectResult OkBase(RequestBase request, ResponseBase response)
    {
        var newHash = request.GetHash();
        // if (!Settings.IsDevelopment && newHash != request.Hash)
        // {
        //     throw new ApiException($"Invalid request hash on  server side, TraceId: {request.TraceId}");
        // }
        response.Agent = Settings.Agent;
        response.TraceId = request.TraceId;
        response.TimeStamp = DateTime.UtcNow.Ticks;
        response.Hash = response.GetHash();
        return base.Ok(response);
    }
}
