using System.ComponentModel;

namespace SevenSeals.Tss.Contour.Api;

public class RelayRequest: SpotRequest
{
    [DefaultValue(1)] public int RelayPort { get; set; } = 1;
}

public class RelayOnRequest: RelayRequest
{
    [DefaultValue(3)] public int Interval { get; set; } = 3;

    public bool SuppressDoorEvent { get; set; }

    public bool RelayOnAnyKey { get; set; }
}

public class RelayOffRequest: RelayRequest;
