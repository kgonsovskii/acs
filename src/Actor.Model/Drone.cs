namespace SevenSeals.Tss.Actor;

public class Drone : Card
{
    public override CardType Type { get; set; } = CardType.Drone;
    public string SerialNumber {get; set;} = null!;
    public string FirmwareVersion {get; set;} = null!;
}
