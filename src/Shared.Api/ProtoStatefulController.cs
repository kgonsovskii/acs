using Microsoft.AspNetCore.Mvc;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoStatefulController: ProtoController<IProtoRequest, IProtoResponse>
{
    protected ProtoStatefulController(Settings settings) : base(settings)
    {
    }

    protected override OkObjectResult OkProto(object response)
    {
        var result = base.OkProto(response);
        var selfAddress = GetSelfAddress();
        if (!string.IsNullOrEmpty(selfAddress))
        {
            HttpContext.Response.Headers[ProtoHeaders.SelfAddress] = selfAddress;
        }

        return result;
    }

    protected virtual string? GetSelfAddress()
    {
        var request = HttpContext.Request;
        var scheme = request.Scheme;
        var host = request.Host.Host;
        var port = request.Host.Port;

        var serviceAddress = port.HasValue
            ? $"{scheme}://{host}:{port.Value}"
            : $"{scheme}://{host}";

        return serviceAddress;
    }
}
