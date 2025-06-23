using System.Runtime.Serialization;
using System.Text.Json.Serialization;
using Infra.Db.Attributes;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;

public enum ChannelType
{
    Ip = 0,
    ComPort = 1
}

[KnownType(typeof(ComPortOptions))]
[KnownType(typeof(IpOptions))]
[JsonDerivedType(typeof(ComPortOptions))]
[JsonDerivedType(typeof(IpOptions))]
[JsonConverter(typeof(ChannelOptionsJsonConverter))]
public abstract class ChannelOptions
{
    [DbEnumTable]
    public virtual ChannelType Type { get; set; } = ChannelType.Ip;

    public IpOptions AsIpOptions() => (this as IpOptions)!;

    public ComPortOptions AsComPortOptions() => (this as ComPortOptions)!;
}

public class ChannelOptionsJsonConverter : GenericDiscriminantConverter<ChannelType, ChannelOptions>
{
    public ChannelOptionsJsonConverter() : base(new Dictionary<Enum, Type>()
    {
        { ChannelType.Ip, typeof(IpOptions) },
        { ChannelType.ComPort, typeof(ComPortOptions) }
    }) { }
}
