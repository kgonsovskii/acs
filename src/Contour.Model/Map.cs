using System.Diagnostics.CodeAnalysis;

namespace SevenSeals.Tss.Contour;

public class ContourMap
{
    public SpotMap[] Spots { get; set; } = [];
}

[SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
public class SpotMap
{
    public ChannelOptions Options { get; set; } = new IpOptions();

    public string[] Addresses { get; set; } = [];
}
