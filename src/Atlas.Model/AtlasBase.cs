using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public abstract class AtlasBase: StructuralItem<Guid>, IProtoRequest, IProtoResponse
{
    public ProtoHeader Headers { get; set; }
}
