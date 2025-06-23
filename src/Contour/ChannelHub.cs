using Microsoft.Extensions.Options;
using SevenSeals.Tss.Contour.Api;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Contour;


public class ChannelHub : HubBase<string, Channel>
{
    private readonly ContourOptions _options;
    private readonly AppState _appState;
    public ChannelHub(IOptions<ContourOptions> settings, AppState state)
    {
        _options = settings.Value;
        _appState = state;
    }

    public async Task<Channel> OpenChannel(ContourRequest request)
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
            await channel.Open();
        }
        return channel;
    }
}
