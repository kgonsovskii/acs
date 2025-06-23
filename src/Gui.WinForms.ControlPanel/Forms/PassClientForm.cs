using SevenSeals.Tss.Actor;

namespace Gui.WinForms.Forms;

public partial class PassClientForm : StorageForm<Pass, Guid, IPassClient>
{
    public PassClientForm(IPassClient client) : base(client, "Pass Management") { }
}
