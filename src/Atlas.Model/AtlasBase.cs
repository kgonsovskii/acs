using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public abstract class AtlasBase: IItem<Guid>, IProtoRequest, IProtoResponse
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Hint { get; set; } = string.Empty;
    public Guid GetId()
    {
        return Id;
    }

    public ProtoHeader Headers { get; set; }
}
