using Microsoft.AspNetCore.Mvc;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoStorageController<TItem, TId, TStorage>: ProtoStorageController<TItem, TId, TStorage, IProtoRequest, IProtoResponse>
    where TStorage : IBaseStorage<TItem, TId> where TItem : IItem<TId>
{
    protected ProtoStorageController(Settings settings, TStorage storage) : base(storage, settings)
    {
    }
}

public abstract class ProtoStorageController<TItem, TId, TStorage, TRequest, TResponse>: ProtoController where TRequest : IProtoRequest where TResponse : IProtoResponse
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
    public virtual ActionResult<TItem> GetById([FromRoute] TId id)
    {
        var item = Storage.GetById(id);
        if (item == null)
        {
            return NotFound();
        }
        return Ok(item);
    }

    [HttpPost]
    public virtual ActionResult<TItem> Add(TItem item)
    {
        Storage.Create(item);
        return GetById(item.Id);
    }

    [HttpPut("{id}")]
    public virtual IActionResult Update([FromRoute] TId id, [FromBody] TItem item)
    {
        var existingItem = Storage.GetById(id);
        if (existingItem == null)
        {
            return NotFound();
        }

        Storage.Update(id, item);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public virtual IActionResult Delete([FromRoute] TId id)
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
