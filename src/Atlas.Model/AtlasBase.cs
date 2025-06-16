using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Atlas;

public abstract class AtlasBase: IItem<Guid>
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string Name { get; set; } = string.Empty;
    public string Hint { get; set; } = string.Empty;
    public Guid GetId()
    {
        return Id;
    }
}
