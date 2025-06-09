namespace SevenSeals.Tss.Contour;

public class AppSnapshot
{
    public SpotHub SpotHub { get; set; }

    public ChannelHub ChannelHub { get; set; }

    public AppSnapshot(SpotHub spotHub, ChannelHub channelHub)
    {
        SpotHub = spotHub;
        ChannelHub = channelHub;
    }

    public void Clean()
    {
        SpotHub.Events.Clear();
    }

    public SnapshotState State
    {
        get
        {
            var result = new SnapshotState()
            {
                Channels = ChannelHub.Map.Values.ToList().Select(a =>
                    new
                    {
                        a.Id, a.IsPolling
                    }),
                Spots = SpotHub.Map.Values.ToList().Select(a =>
                    new
                    {
                        a.Address, a.ProgId, a.IsAlarm
                    })
            };
            return result;
        }
    }

    public SnapshotEvents Events
    {
        get
        {
            var result = new SnapshotEvents()
            {
                Events = SpotHub.Events.ToArray()
            };
            return result;
        }
    }

    public class SnapshotState
    {
        public object Channels { get; set; }

        public object Spots { get; set; }
    }

    public class SnapshotEvents
    {
        public object Events { get; set; }
    }
}
