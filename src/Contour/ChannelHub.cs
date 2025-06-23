using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;


public class ChannelHub : HubBase<string, Channel>
{
    private readonly ContourOptions _options;
    private readonly AppState _appState;
    private readonly ILogger<ChannelHub> _logger;
    public ChannelHub(IOptions<ContourOptions> settings, AppState state, ILogger<ChannelHub> logger)
    {
        _options = settings.Value;
        _appState = state;
        _logger = logger;
    }

    public async Task<Channel> OpenChannel(ContourRequest request, bool openAnyway)
    {
        Channel channel;
        if (request.Options.Type == ChannelType.ComPort)
        {
            channel = new ComPortChannel(_options, request.AsComPortOptions(), _appState.CancellationToken);
        }
        else
        {
            channel = new IpChannel(_options, request.AsIpOptions(), _appState.CancellationToken);
        }

        if (Map.TryGetValue(channel.Id, out var value))
        {
            channel = value;
        }
        else
        {
            Map.TryAdd(channel.Id, channel);
            if (openAnyway)
            {
                try
                {
                    await channel.Open();
                }
                catch(Exception e)
                {
                    _logger.LogError(e, "Cant open channel");
                }
            }
            else
            {
                await channel.Open();
            }
        }
        return channel;
    }
}
