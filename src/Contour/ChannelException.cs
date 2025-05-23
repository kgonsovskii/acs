namespace SevenSeals.Tss.Contour;

public class ChannelException: ContourException
{
    public ChannelException(Channel ch, string className, string msg) :  base(className, $"Channel<{ch.ConnInfo()}>: {msg}")
    {
    }
}
