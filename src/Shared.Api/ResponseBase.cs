using System.Text.Json.Serialization;

namespace SevenSeals.Tss.Shared;

public abstract class ResponseBase: Proto
{
    [JsonIgnore]
    public long TimeStamp { get; set; } = 0;
}
