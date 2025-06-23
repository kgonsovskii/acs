using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Logic.Controllers;

public class BaseController: ProtoController<IProtoRequest, IProtoResponse>
{
    public BaseController(Settings settings) : base(settings)
    {
    }
}
