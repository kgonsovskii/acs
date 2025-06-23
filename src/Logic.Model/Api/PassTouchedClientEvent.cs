using SevenSeals.Tss.Actor;

namespace SevenSeals.Tss.Logic.Api;

public class PassTouchedClientEvent
{
    public required bool AccessGranted { get; set; }
    public required string Reason { get; set; }
    public required Member? Member { get; set; }
    public required  Pass? Pass { get; set; }
}
