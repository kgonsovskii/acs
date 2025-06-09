using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Controllers;

public class BaseController: ProtoController<SpotRequest, SpotResponse>
{
    public BaseController(Settings settings) : base(settings)
    {
    }

    protected OkObjectResult Ok(Contour contour, SpotRequest request, SpotResponse? response)
    {
        response ??= new SpotResponse()
        {
            SessionId = contour.Channel.Id
        };
        return base.Ok(request, response);
    }
}
