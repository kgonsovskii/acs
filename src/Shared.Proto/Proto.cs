using System.Text.Json.Serialization;

namespace SevenSeals.Tss.Shared;

public interface IProto;

public interface IProtoRequest: IProto;

public interface IProtoResponse: IProto;

public abstract class Proto: IProto;

public class ProtoRequest: Proto, IProtoRequest;

public class ProtoResponse: Proto, IProtoResponse;

public interface IMany<T> : IEnumerable<T>, IProtoResponse;

public class Many<T> : List<T>, IMany<T>;

public class ProtoHeader
{
    /// <summary>
    /// Trace identifier for correlating requests.
    /// </summary>
    [JsonIgnore]
    public string TraceId { get; set; } = string.Empty;

    /// <summary>
    /// Agent with Machine-Code identifier for correlating requests.
    /// </summary>
    [JsonIgnore]
    public string Agent { get; set; } = string.Empty;

    [JsonIgnore]
    public int Chop { get; set; } = 1;

    [JsonIgnore]
    public int Hash { get; set; } = 0;

    [JsonIgnore]
    public string Version { get; set; }= string.Empty;

    [JsonIgnore]
    public long TimeStamp { get; set; }
}

