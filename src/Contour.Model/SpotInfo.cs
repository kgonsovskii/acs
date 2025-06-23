namespace SevenSeals.Tss.Contour;

public class SpotInfo
{
    public required ChannelOptions ChannelOptions { get; set; }
    public required string Address { get; set; }
    public required int ProgId { get; set; }
    public required bool IsAlarm { get; set; }
}

