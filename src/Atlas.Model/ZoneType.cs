﻿using System.Text.Json.Serialization;

namespace SevenSeals.Tss.Atlas;

[JsonConverter(typeof(JsonStringEnumConverter))]
public enum ZoneType
{
    Building,
    Floor,
    Room,
    Corridor,
    Lobby,
    Elevator,
    Staircase,
    Parking,
    ExternalArea
}
