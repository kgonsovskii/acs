using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Logic.Controllers;

public class BaseController: ProtoController<IProtoRequest, IProtoResponse>
{
    public BaseController(Settings settings) : base(settings)
    {
    }
}
