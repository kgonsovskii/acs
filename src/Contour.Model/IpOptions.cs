﻿using System.ComponentModel;
using System.Text.Json.Serialization;

namespace SevenSeals.Tss.Contour;

public class IpOptions: ChannelOptions
{
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public override ChannelType Type { get; set; } = ChannelType.Ip;
    public string Host { get; set; } = string.Empty;

    [DefaultValue(5086)]
    public int Port { get; set; } = 5086;

    public override string ToString()
    {
        return $"Type={Type}, Host={Host}, Port={Port}";
    }
}
