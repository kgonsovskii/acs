using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Actor.Storage;

namespace SevenSeals.Tss.Actor.Controllers;

[ApiController]
[Route("api/[controller]")]
public class KeyController : ControllerBase
{
    private readonly IKeyStorage _storage;
    private readonly IActorStorage _actorStorage;
    private readonly ILogger<KeyController> _logger;

    public KeyController(IKeyStorage storage, IActorStorage personStorage, ILogger<KeyController> logger)
    {
        _storage = storage;
        _actorStorage = personStorage;
        _logger = logger;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Key>> GetAll()
    {
        return Ok(_storage.GetAll());
    }

    [HttpGet("{id}")]
    public ActionResult<Key> GetById(Guid id)
    {
        var key = _storage.GetById(id);
        if (key == null)
        {
            return NotFound();
        }
        return Ok(key);
    }

    [HttpPost]
    public ActionResult<Key> Create(Key key)
    {
        _storage.Create(key);
        return CreatedAtAction(nameof(GetById), new { id = key.Id }, key);
    }

    [HttpPut("{id}")]
    public IActionResult Update(Guid id, Key key)
    {
        if (id != key.Id)
        {
            return BadRequest();
        }

        var existingKey = _storage.GetById(id);
        if (existingKey == null)
        {
            return NotFound();
        }

        _storage.Update(key);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public IActionResult Delete(Guid id)
    {
        var key = _storage.GetById(id);
        if (key == null)
        {
            return NotFound();
        }

        _storage.Delete(id);
        return NoContent();
    }

    [HttpGet("person/{personId}")]
    public ActionResult<IEnumerable<Key>> GetByPerson(Guid personId)
    {
        return Ok(_storage.GetByPerson(personId));
    }

    [HttpPost("{keyId}/assign/{personId}")]
    public IActionResult AssignKey(Guid keyId, Guid personId)
    {
        var key = _storage.GetById(keyId);
        if (key == null)
        {
            return NotFound("Key not found");
        }

        var person = _personStorage.GetById(personId);
        if (person == null)
        {
            return NotFound("Person not found");
        }

        _storage.AssignToPerson(keyId, personId);
        return NoContent();
    }

    [HttpPost("{keyId}/deactivate")]
    public IActionResult DeactivateKey(Guid keyId, [FromBody] KeyStatus status)
    {
        var key = _storage.GetById(keyId);
        if (key == null)
        {
            return NotFound();
        }

        _storage.Deactivate(keyId, status);
        return NoContent();
    }
}
