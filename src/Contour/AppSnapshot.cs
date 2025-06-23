using SevenSeals.Tss.Contour.Events;

namespace SevenSeals.Tss.Contour;

public class AppSnapshot
{
    private ContourHub ContourHub { get; set; }

    private ChannelHub ChannelHub { get; set; }

    public AppSnapshot(ContourHub contourHub, ChannelHub channelHub)
    {
        ContourHub = contourHub;
        ChannelHub = channelHub;
    }

    public void Clean()
    {
        ContourHub.ClearEvents();
    }

    public SnapshotState State
    {
        get
        {
            var result = new SnapshotState()
            {
                Channels = ChannelHub.Map.Values.ToList().Select(a =>
                    new ChannelInfo
                    {
                        Id = a.Id,
                        IsPolling = a.IsPolling
                    }).ToList(),
                Spots = ContourHub.Map.Values.ToList().Select(a =>
                    new SpotInfo
                    {
                        Address = a.Address,
                        ProgId = a.ProgId,
                        IsAlarm = a.IsAlarm
                    }).ToList()
            };
            return result;
        }
    }

    public List<ControllerEvent> Events => ContourHub.GetEventsSnapshot();


}
