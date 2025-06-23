using SevenSeals.Tss.Atlas;

namespace Gui.WinForms.Forms;

public partial class TransitClientForm : StorageForm<Transit, Guid, ITransitClient>
{
    public TransitClientForm(ITransitClient client, string? title = null) : base(client, title ?? "Transit Management") { }

    public TransitClientForm() {
        InitializeComponent();
    }
} 