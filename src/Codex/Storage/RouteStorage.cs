using System.Diagnostics.CodeAnalysis;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Codex.Storage;

public interface IRouteStorage : IBaseStorage<RouteRule, Guid>
{

}

public class RouteStorage: BaseStorage<RouteRule, Guid>, IRouteStorage
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public RouteStorage(Settings settings, ILogger<RouteStorage> logger) : base(settings, logger)
    {
    }
}
