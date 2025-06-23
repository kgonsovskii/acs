using SevenSeals.Tss.Codex;

namespace Gui.WinForms.Forms;

public partial class RouteClientForm : StorageForm<RouteRule, Guid, IRouteClient>
{
    public RouteClientForm(IRouteClient client, string? title = null) : base(client, title ?? "Route Management") { }

    public RouteClientForm() {
        InitializeComponent();
    }
} 