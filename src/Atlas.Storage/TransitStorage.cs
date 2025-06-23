using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public interface ITransitStorage : IBaseStorage<Transit, Guid>;

public class TransitStorage: BaseStorage<Transit, Guid>, ITransitStorage
{
    public TransitStorage(Settings settings, ILogger<TransitStorage> logger) : base(settings, logger)
    {
    }
}
