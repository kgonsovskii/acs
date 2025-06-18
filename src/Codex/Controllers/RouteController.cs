using System.Diagnostics.CodeAnalysis;
using SevenSeals.Tss.Codex.Storage;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Codex.Controllers;

public class RouteController : ProtoStorageController<RouteRule, Guid, IRouteStorage, RouteRule, RouteRule>
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public RouteController(IRouteStorage storage, Settings settings) : base(storage, settings)
    {
    }
}
