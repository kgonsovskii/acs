using SevenSeals.Tss.Atlas;

namespace Gui.WinForms.Forms;

public partial class ZoneClientForm : StorageForm<Zone, Guid, IZoneClient>
{
    public ZoneClientForm(IZoneClient client, string? title = null) : base(client, title ?? "Zone Management") { }

    public ZoneClientForm() {
        InitializeComponent();
    }
} 