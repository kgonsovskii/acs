namespace SevenSeals.Tss.Contour;


public class Controller
{
    public byte Address { get; }
    public Channel Channel { get; set; }

    public Controller(byte address)
    {
        Address = address;
    }

    public async Task PollOffAsync(bool forceAuto)
    {
        // Implementation for poll off
        await Task.CompletedTask;
    }

    public async Task PollOnAsync(bool isAuto, bool isReliable)
    {
        // Implementation for poll on
        await Task.CompletedTask;
    }
}
