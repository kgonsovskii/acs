using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour.Controllers;

public class BaseController: ProtoController<SpotRequest, SpotResponse>
{
    public BaseController(Settings settings) : base(settings)
    {
    }

    protected OkObjectResult Ok(Spot spot, SpotRequest request, SpotResponse? response)
    {
        response ??= new SpotResponse()
        {
            SessionId = spot.Channel.Id
        };
        return base.Ok(request, response);
    }
}
