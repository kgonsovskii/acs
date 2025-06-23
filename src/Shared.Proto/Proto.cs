using System.Collections;
using System.Text.Json.Serialization;

namespace SevenSeals.Tss.Shared;

public interface IProto;

public interface IProtoRequest: IProto;

public interface IProtoResponse: IProto;

public abstract class Proto: IProto;

public class ProtoRequest: Proto, IProtoRequest;

public class ProtoResponse: Proto, IProtoResponse;

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

public interface IProtoStateRequest: IProtoRequest;

public class ProtoStateRequest : ProtoRequest, IProtoStateRequest
{

}

public interface IProtoStateResponse: IProtoResponse;

public class ProtoStateResponse : ProtoResponse, IProtoStateResponse
{

}

public interface IProtoEventsRequest: IProtoRequest;

public class ProtoEventsRequest : ProtoRequest, IProtoEventsRequest
{

}

public interface IProtoEventsResponse : IProtoResponse
{
    public IList Events { get; set; }
}

public class ProtoEventsResponse : ProtoResponse, IProtoEventsResponse
{
    public required IList Events { get; set; }
}

public interface IProtoEvent
{

}

public abstract class ProtoEvent: IProtoEvent
{

}
