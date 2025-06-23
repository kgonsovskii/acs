using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Controllers;

public class BaseController: ProtoController<IProtoRequest, IProtoResponse>
{
    public BaseController(Settings settings) : base(settings)
    {
    }

    protected OkObjectResult OkSpot(Contour contour, ContourRequest request, ContourResponse? response)
    {
        response ??= new ContourResponse()
        {
            SessionId = contour.Channel.Id
        };
        return OkProto(response);
    }
}
