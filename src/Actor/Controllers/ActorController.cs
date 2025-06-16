using Microsoft.AspNetCore.Mvc;
using SevenSeals.Tss.Actor.Storage;

namespace SevenSeals.Tss.Actor.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ActorController : ControllerBase
{
    private readonly ActorStorage _storage;
    private readonly ILogger<ActorController> _logger;

    public ActorController(ActorStorage storage, ILogger<ActorController> logger)
    {
        _storage = storage;
        _logger = logger;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Person>> GetAll()
    {
        return Ok(_storage.GetAll());
    }

    [HttpGet("{id}")]
    public ActionResult<Person> GetById(string id)
    {
        var person = _storage.GetById(id);
        if (person == null)
        {
            return NotFound();
        }
        return Ok(person);
    }

    [HttpPost]
    public ActionResult<Person> Create(Person person)
    {
        _storage.Create(person);
        return CreatedAtAction(nameof(GetById), new { id = person.Id }, person);
    }

    [HttpPut("{id}")]
    public IActionResult Update(string id, Person person)
    {
        if (id != person.Id)
        {
            return BadRequest();
        }

        var existingPerson = _storage.GetById(id);
        if (existingPerson == null)
        {
            return NotFound();
        }

        _storage.Update(person);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public IActionResult Delete(string id)
    {
        var person = _storage.GetById(id);
        if (person == null)
        {
            return NotFound();
        }

        _storage.Delete(id);
        return NoContent();
    }
}
