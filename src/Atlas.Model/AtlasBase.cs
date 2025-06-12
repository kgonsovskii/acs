namespace SevenSeals.Tss.Atlas;

public abstract class AtlasBase
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string Name { get; set; } = string.Empty;
    public string Hint { get; set; } = string.Empty;
}
