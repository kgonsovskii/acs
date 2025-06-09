namespace SevenSeals.Tss.Shared;

public class ContourMap
{
    public SpotMap[] Spots { get; set; } = [];
}

public class SpotMap
{
    public ChannelOptions Options { get; set; }

    public string[] Addresses { get; set; } = [];
}
