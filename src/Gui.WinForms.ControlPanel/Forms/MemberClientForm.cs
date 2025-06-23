using SevenSeals.Tss.Actor;

namespace Gui.WinForms.Forms;

public partial class MemberClientForm : StorageForm<Member, Guid, IMemberClient>
{
    public MemberClientForm(IMemberClient client) : base(client, "Member Management") { }
}
