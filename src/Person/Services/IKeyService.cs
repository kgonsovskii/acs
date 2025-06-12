using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using SevenSeals.Tss.Person;

namespace SevenSeals.Tss.Person.Services;

public interface IKeyService
{
    Task<IEnumerable<Key>> GetKeysAsync();
    Task<Key?> GetKeyAsync(Guid id);
    Task<IEnumerable<Key>> GetKeysByPersonAsync(Guid personId);
    Task<Key> CreateKeyAsync(Key key);
    Task<bool> UpdateKeyAsync(Guid id, Key key);
    Task<bool> DeleteKeyAsync(Guid id);
    Task<bool> AssignKeyToPersonAsync(Guid keyId, Guid personId);
    Task<bool> DeactivateKeyAsync(Guid keyId, KeyStatus status);
} 