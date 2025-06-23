using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Contour.Events;

namespace Contour.TestConsole;

public class TestTool
{
    private readonly ILogger<TestTool> _logger;

    public TestTool(ILogger<TestTool> logger)
    {
        _logger = logger;
    }

    public async Task StartPolling()
    {
        var channel = new IpChannel(
            new ContourOptions(),
            new IpOptions() { Host = "192.168.0.112", Port = 5086 },
            CancellationToken.None
        );
        await channel.Open();
        var spot = new SevenSeals.Tss.Contour.Contour(null, channel, 171);
        spot.Poll();
        int eventCount = 0;

        // Use the new proper event system instead of raw byte array handling
        spot.OnEvent += (sender, evt) =>
        {
            if (evt.Kind == ContourEvent.KindEnum.Key || evt.Kind == ContourEvent.KindEnum.DoorClose)
            {
                eventCount++;
                var logMessage = $"ContourEvent: {evt.Kind} Controller: {evt.ChannelId}, Address: {evt.Address}, Time: {evt.ControllerTimestamp}";

                // Add key hex string for key events
                if (evt is ContourKeyEvent keyEvent)
                {
                    logMessage += $", Key: {keyEvent.KeyNumber}";
                }

                Log(logMessage);
            }

            // Enrich logging for base ContourEvent (when it's not a specific subclass)
            if (evt is ContourEvent && 1 ==0)
            {
                Log($"=== Base ContourEvent Details ===");
                Log($"Kind: {evt.Kind}");
                Log($"ChannelId: {evt.ChannelId}");
                Log($"Address: {evt.Address}");
                Log($"No: {evt.No}");
                Log($"IsAuto: {evt.IsAuto}");
                Log($"IsLast: {evt.IsLast}");
                Log($"HasYear: {evt.HasYear}");
                Log($"HasDate: {evt.HasDate}");
                Log($"ControllerTimestamp: {evt.ControllerTimestamp}");
                Log($"Used: {evt.Used}");
                Log($"Timestamp: {evt.Timestamp}");
                Log($"Type: {evt.Type}");

                // Log raw data as hex string
                var dataHex = BitConverter.ToString(evt.Data).Replace("-", " ");
                Log($"Raw Data (hex): {dataHex}");

                // Log individual data bytes with their meanings
                Log($"Data[0]: {evt.Data[0]:X2} (timestamp byte 0)");
                Log($"Data[1]: {evt.Data[1]:X2} (event type and port)");
                Log($"Data[2-7]: {BitConverter.ToString(evt.Data, 2, 6).Replace("-", " ")} (key data)");
                Log($"Data[8-9]: {BitConverter.ToString(evt.Data, 8, 2).Replace("-", " ")} (No - little endian)");
                Log($"Data[10]: {evt.Data[10]:X2} (date day)");
                Log($"Data[11]: {evt.Data[11]:X2} (date month + year flag)");
                Log($"Data[12]: {evt.Data[12]:X2} (auto flag + access control bits)");
                Log($"Data[13]: {evt.Data[13]:X2} (timestamp second)");
                Log($"Data[14]: {evt.Data[14]:X2} (timestamp minute)");
                Log($"Data[15]: {evt.Data[15]:X2} (timestamp hour)");

                Log($"=== End Base ContourEvent Details ===");
            }
            return Task.CompletedTask;
        };

        await Task.Delay(50000);
        // No assertion: just ensure no exceptions and event can be received
    }

    private void Log(string message)
    {
        _logger.LogInformation(message);
    }
}
