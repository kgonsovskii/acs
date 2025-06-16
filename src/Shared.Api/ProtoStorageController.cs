using Microsoft.AspNetCore.Mvc;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoStorageController<TItem, TId, TStorage>: ProtoStorageController<TItem, TId, TStorage, RequestBase, ResponseBase>
    where TStorage : IBaseStorage<TItem, TId> where TItem : IItem<TId>
{
    protected ProtoStorageController(Settings settings, TStorage storage) : base(storage, settings)
    {
    }
}

[ApiController][Route("api/[controller]")]
public abstract class ProtoStorageController<TItem, TId, TStorage, TRequest, TResponse>: ProtoController where TRequest : RequestBase where TResponse : ResponseBase
    where TStorage : IBaseStorage<TItem, TId> where TItem : IItem<TId>
{
    protected TStorage Storage { get; }
    protected ProtoStorageController(TStorage storage, Settings settings) : base(settings)
    {
        Storage = storage;
    }

    [HttpGet]
    public virtual ActionResult<IEnumerable<TItem>> GetAll()
    {
        return Ok(Storage.GetAll());
    }

    [HttpGet("{id}")]
    public virtual ActionResult<TItem> GetById(TId id)
    {
        var item = Storage.GetById(id);
        if (item == null)
        {
            return NotFound();
        }
        return Ok(item);
    }

    [HttpPost]
    public virtual ActionResult<TItem> Create(TItem item)
    {
        Storage.Create(item);
        return GetById(item.Id);
    }

    [HttpPut("{id}")]
    public virtual IActionResult Update(TId id, TItem item)
    {
        if (id!.ToString() != item.Id!.ToString())
        {
            return BadRequest();
        }

        var existingItem = Storage.GetById(id);
        if (existingItem == null)
        {
            return NotFound();
        }

        Storage.Update(item);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public virtual IActionResult Delete(TId id)
    {
        var item = Storage.GetById(id);
        if (item == null)
        {
            return NotFound();
        }

        Storage.Delete(id);
        return NoContent();
    }
}
