using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Api.Controllers;

[ApiController]
[Route("api/[controller]/")]
public class GeneralController : ProtoController
{
    public GeneralController(Settings settings) : base(settings)
    {
    }
}
