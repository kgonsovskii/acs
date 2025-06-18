using System.Diagnostics.CodeAnalysis;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor.Storage;

public interface IKeyStorage : IBaseStorage<Key, Guid>
{

}

public class KeyStorage: BaseStorage<Key, Guid>, IKeyStorage
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public KeyStorage(Settings settings, ILogger<KeyStorage> logger) : base(settings, logger)
    {
    }
}
