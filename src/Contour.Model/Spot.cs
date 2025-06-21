using System.Diagnostics.CodeAnalysis;
using Infra.Db;
using Infra.Db.Attributes;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

[DbTable]
[SuppressMessage("ReSharper", "ClassNeverInstantiated.Global")]
public class Spot: StructuralItem<Guid>, IProtoRequest, IProtoResponse
{
    [DbPolymorphicTable(typeof(IpOptions), typeof(ComPortOptions))]
    public ChannelOptions Options { get; set; } = new IpOptions();

    [DbChildTable]
    public string[] Addresses { get; set; } = [];
}
