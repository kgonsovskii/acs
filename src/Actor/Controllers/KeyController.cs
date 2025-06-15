using Microsoft.AspNetCore.Mvc;

namespace SevenSeals.Tss.Actor.Controllers;

[ApiController]
[Route("api/person/keys")]
public class KeyController : ControllerBase
{
    private readonly IKeyService _keyService;

    public KeyController(IKeyService keyService)
    {
        _keyService = keyService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Key>>> GetKeys()
    {
        var keys = await _keyService.GetKeysAsync();
        return Ok(keys);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Key>> GetKey(Guid id)
    {
        var key = await _keyService.GetKeyAsync(id);
        if (key == null)
        {
            return NotFound();
        }
        return Ok(key);
    }

    [HttpGet("person/{personId}")]
    public async Task<ActionResult<IEnumerable<Key>>> GetKeysByPerson(Guid personId)
    {
        var keys = await _keyService.GetKeysByPersonAsync(personId);
        return Ok(keys);
    }

    [HttpPost]
    public async Task<ActionResult<Key>> CreateKey(Key key)
    {
        var createdKey = await _keyService.CreateKeyAsync(key);
        return CreatedAtAction(nameof(GetKey), new { id = createdKey.Id }, createdKey);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateKey(Guid id, Key key)
    {
        if (id != key.Id)
        {
            return BadRequest();
        }

        var result = await _keyService.UpdateKeyAsync(id, key);
        if (!result)
        {
            return NotFound();
        }

        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteKey(Guid id)
    {
        var result = await _keyService.DeleteKeyAsync(id);
        if (!result)
        {
            return NotFound();
        }

        return NoContent();
    }

    [HttpPost("{keyId}/assign/{personId}")]
    public async Task<IActionResult> AssignKeyToPerson(Guid keyId, Guid personId)
    {
        var result = await _keyService.AssignKeyToPersonAsync(keyId, personId);
        if (!result)
        {
            return NotFound();
        }

        return NoContent();
    }

    [HttpPost("{keyId}/deactivate")]
    public async Task<IActionResult> DeactivateKey(Guid keyId, [FromBody] KeyStatus status)
    {
        var result = await _keyService.DeactivateKeyAsync(keyId, status);
        if (!result)
        {
            return NotFound();
        }

        return NoContent();
    }
} 