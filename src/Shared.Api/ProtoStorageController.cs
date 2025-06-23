using Infra;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

namespace SevenSeals.Tss.Shared;

public abstract class ProtoStorageController<TItem, TId, TStorage>: ProtoStorageController<TItem, TId, TStorage, IProtoRequest, IProtoResponse>
    where TStorage : IBaseStorage<TItem, TId> where TItem : IItem<TId> where TId : struct
{
    protected ProtoStorageController(Settings settings, TStorage storage) : base(storage, settings)
    {
    }
}

public abstract class ProtoStorageController<TItem, TId, TStorage, TRequest, TResponse>: ProtoController where TRequest : IProtoRequest where TResponse : IProtoResponse
    where TStorage : IBaseStorage<TItem, TId> where TItem : IItem<TId> where TId : struct
{
    protected TStorage Storage { get; }
    protected ProtoStorageController(TStorage storage, Settings settings) : base(settings)
    {
        Storage = storage;
    }

    [HttpGet]
    public virtual ActionResult<IEnumerable<TItem>> GetAll()
    {
        return OkProto(Storage.GetAll());
    }

    [HttpGet("{id}")]
    public virtual ActionResult<TItem> GetById([FromRoute] TId id)
    {
        var item = Storage.GetById(id);
        if (item == null)
        {
            return NotFound();
        }
        return OkProto(item);
    }

    [HttpPost]
    public virtual ActionResult<TItem> Add(TItem item)
    {
        Storage.Create(item);
        return GetById(item.Id);
    }

    [HttpPut("{id}")]
    public virtual ActionResult<TItem> Update([FromRoute] TId id, [FromBody] TItem item)
    {
        var existingItem = Storage.GetById(id);
        if (existingItem == null)
        {
            return NotFound();
        }

        Storage.Update(id, item);
        return GetById(id);
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

    [HttpGet("by-field/{fieldName}/{value}")]
    public virtual ActionResult<IEnumerable<TItem>> GetByField([FromRoute] string fieldName, [FromRoute] string value)
    {
        object typedValue = value;
        if (string.Equals(fieldName, "Id", StringComparison.OrdinalIgnoreCase) || fieldName.EndsWith("Id", StringComparison.OrdinalIgnoreCase))
        {
            if (Guid.TryParse(value, out var guid))
                typedValue = guid;
        }
        return OkProto(Storage.GetByField(fieldName, typedValue));
    }

    [HttpPost("by-fields")]
    public virtual ActionResult<IEnumerable<TItem>> GetByFields([FromBody] Dictionary<string, object> criteria)
    {
        var typedCriteria = new Dictionary<string, object>();
        foreach (var kvp in criteria)
        {
            object typedValue = kvp.Value;
            if (string.Equals(kvp.Key, "Id", StringComparison.OrdinalIgnoreCase) || kvp.Key.EndsWith("Id", StringComparison.OrdinalIgnoreCase))
            {
                if (kvp.Value is string s && Guid.TryParse(s, out var guid))
                    typedValue = guid;
                else if (kvp.Value is System.Text.Json.JsonElement jsonElement && jsonElement.ValueKind == System.Text.Json.JsonValueKind.String)
                {
                    var stringValue = jsonElement.GetString();
                    if (Guid.TryParse(stringValue, out var guidFromJson))
                        typedValue = guidFromJson;
                }
            }
            typedCriteria[kvp.Key] = typedValue;
        }
        return OkProto(Storage.GetByFields(typedCriteria));
    }

    [HttpPost("by-where")]
    public virtual ActionResult<IEnumerable<TItem>> GetByWhere([FromBody] WhereRequest request)
    {
        var typedParams = new Dictionary<string, object>();
        foreach (var kvp in request.Parameters ?? new Dictionary<string, object>())
        {
            object typedValue = kvp.Value;
            
            // Handle Guid parameters - check both the key name and the value type
            if (kvp.Key.EndsWith("id", StringComparison.OrdinalIgnoreCase) || 
                kvp.Key.Equals("Id", StringComparison.OrdinalIgnoreCase))
            {
                if (kvp.Value is string s && Guid.TryParse(s, out var guid))
                    typedValue = guid;
                else if (kvp.Value is JsonElement jsonElement && jsonElement.ValueKind == JsonValueKind.String)
                {
                    var stringValue = jsonElement.GetString();
                    if (Guid.TryParse(stringValue, out var guidFromJson))
                        typedValue = guidFromJson;
                }
            }
            
            // Handle boolean parameters
            if (kvp.Value is string boolString && (boolString.Equals("true", StringComparison.OrdinalIgnoreCase) || 
                                                  boolString.Equals("false", StringComparison.OrdinalIgnoreCase)))
            {
                if (bool.TryParse(boolString, out var boolValue))
                    typedValue = boolValue;
            }
            
            typedParams[kvp.Key] = typedValue;
        }
        return OkProto(Storage.GetByWhere(request.WhereClause, typedParams));
    }

    [HttpGet("first-by-field/{fieldName}/{value}")]
    public virtual ActionResult<TItem> GetFirstByField([FromRoute] string fieldName, [FromRoute] string value)
    {
        object typedValue = value;
        if (string.Equals(fieldName, "Id", StringComparison.OrdinalIgnoreCase) || fieldName.EndsWith("Id", StringComparison.OrdinalIgnoreCase))
        {
            if (Guid.TryParse(value, out var guid))
                typedValue = guid;
        }
        var item = Storage.GetFirstByField(fieldName, typedValue);
        if (item == null)
        {
            return NotFound();
        }
        return OkProto(item);
    }

    [HttpGet("exists-by-field/{fieldName}/{value}")]
    public virtual ActionResult<bool> ExistsByField([FromRoute] string fieldName, [FromRoute] string value)
    {
        object typedValue = value;
        if (string.Equals(fieldName, "Id", StringComparison.OrdinalIgnoreCase) || fieldName.EndsWith("Id", StringComparison.OrdinalIgnoreCase))
        {
            if (Guid.TryParse(value, out var guid))
                typedValue = guid;
        }
        return OkProto(Storage.ExistsByField(fieldName, typedValue));
    }
}
