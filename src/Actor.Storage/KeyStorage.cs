using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public interface IKeyStorage : IBaseStorage<Pass, Guid>;

public class KeyStorage: BaseStorage<Pass, Guid>, IKeyStorage
{
    public KeyStorage(Settings settings, ILogger<KeyStorage> logger) : base(settings, logger)
    {
    }
}
