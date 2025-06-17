using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Controllers;

public class BaseController: ProtoController<IProtoRequest, IProtoResponse>
{
    public BaseController(Settings settings) : base(settings)
    {
    }

    protected OkObjectResult OkSpot(Contour contour, SpotRequest request, SpotResponse? response)
    {
        response ??= new SpotResponse()
        {
            SessionId = contour.Channel.Id
        };
        return base.OkProto(request, response);
    }
}
