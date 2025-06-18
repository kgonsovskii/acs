using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public abstract class ActorBase: IItem<Guid>, IProtoRequest, IProtoResponse
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Hint { get; set; } = string.Empty;
    public ProtoHeader Headers { get; set; } = null!;
}
