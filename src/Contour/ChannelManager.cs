namespace SevenSeals.Tss.Contour;


public class ChannelManager: BaseManager<string, Channel>
{
    protected override Channel CreateItem(string key)
    {
        return new Channel(key);
    }
}
