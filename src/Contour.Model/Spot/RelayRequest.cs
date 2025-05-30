namespace Spot;

public class RelayRequest: SpotRequest
{
    public int SportPort { get; set; }
}

public class RelayOnRequest: RelayRequest
{
    public int Interval { get; set; }

    public bool SuppressDoorEvent { get; set; }

    public bool RelayOnAnyKey { get; set; }
}

public class RelayOffRequest: RelayRequest
{
}
