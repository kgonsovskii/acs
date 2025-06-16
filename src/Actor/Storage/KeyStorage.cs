using System.Diagnostics.CodeAnalysis;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor.Storage;

public interface IKeyStorage: IKeyStorage<Key, string>
{
}

public class KeyStorage : KeyStorage<Key, string>, IKeyStorage
{
    [SuppressMessage("ReSharper", "ConvertToPrimaryConstructor")]
    public KeyStorage(Settings settings, ILogger<KeyStorage> logger, IActorStorage<Actor> actorStorage) : base(settings, logger, actorStorage)
    {
    }
}

public interface IKeyStorage<TBody, TId>: IBaseStorage<TBody, TId> where TBody : Key
{
    void AssignToPerson(string keyId, string actorId);
    void SetStatus(string keyId, KeyStatus status);
}

public class KeyStorage<TBody, TId> : BaseStorage<TBody, TId>, IKeyStorage<TBody, TId> where TBody : Key
{
    private readonly IActorStorage<Actor> _actorStorage;

    public KeyStorage(Settings settings, ILogger<KeyStorage> logger, IActorStorage<Actor> actorStorage)
    {
        _actorStorage = actorStorage;
    }

    public void AssignToPerson(string keyId, string actorId)
    {
        throw new NotImplementedException();
    }

    public void SetStatus(string keyId, KeyStatus status)
    {
        throw new NotImplementedException();
    }

    public override IEnumerable<TBody> GetAll()
    {
        throw new NotImplementedException();
    }

    public override TBody? GetById(TId id)
    {
        throw new NotImplementedException();
    }

    public override void Create(TBody item)
    {
        throw new NotImplementedException();
    }

    public override void Update(TBody item)
    {
        throw new NotImplementedException();
    }

    public override void Delete(TId id)
    {
        throw new NotImplementedException();
    }
}
