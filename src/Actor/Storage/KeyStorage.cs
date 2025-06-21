using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor.Storage;

public interface IKeyStorage : IBaseStorage<Pass, Guid>;

public class KeyStorage: BaseStorage<Pass, Guid>, IKeyStorage
{
    public KeyStorage(Settings settings, ILogger<KeyStorage> logger) : base(settings, logger)
    {
    }
}
