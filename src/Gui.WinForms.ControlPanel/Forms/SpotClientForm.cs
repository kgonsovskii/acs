using SevenSeals.Tss.Contour;

namespace Gui.WinForms.Forms;

public partial class SpotClientForm : StorageForm<Spot, Guid, ISpotClient>
{
    public SpotClientForm(ISpotClient client, string? title = null) : base(client, title ?? "Spot Management") { }

    public SpotClientForm() {
        InitializeComponent();
    }
} 