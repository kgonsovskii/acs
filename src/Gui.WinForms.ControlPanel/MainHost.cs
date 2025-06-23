using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Gui.WinForms;

public class MainHost: GuiHost<MainForm>
{
    public MainHost(IServiceProvider services, ILogger<GuiHost<MainForm>> logger, IHostApplicationLifetime applicationLifetime) : base(services, logger, applicationLifetime)
    {
    }
}
