using SevenSeals.Tss.Contour.Events;

namespace SevenSeals.Tss.Contour;

public partial class Contour: ProtoObject
{
    public Channel Channel { get; }
    public override string Id => $"{Channel.Id}-{Address}";
    public Byte Address { get; set; }


    private Task? _pollingTask;

    private bool? _isAlarm;

    private bool _polling;
    private bool _autonomic;

    public DateTime SuspendBefore { get; set; }


    public event Func<Contour, ContourEvent, Task>? OnEvent;

    public Guid? SpotId {get; set;}

    private ContourOptions _options;

    public Contour(Guid? spotId, Channel channel, byte addr, ContourOptions options)
    {
        _options = options;
         Channel = channel;
         Address = addr;
        _polling = false;
        SpotId = spotId;
    }

    public void Poll()
    {
        ReadEvt();
    }

    public string Name => $"Controller_{Address}";
}
