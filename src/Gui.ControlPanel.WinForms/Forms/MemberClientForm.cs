using Actor.Client;
using Actor.Model;
using SevenSeals.Tss.Actor;

namespace Gui.ControlPanel.WinForms.Forms;

public class MemberClientForm : BaseClientForm<MemberClient>
{
    public MemberClientForm(MemberClient client) : base(client)
    {
        Text = "Member Client";
        InitializeButtons();
    }

    private void InitializeButtons()
    {
        // Add buttons for each MemberClient method
        _ = ExecuteClientMethod("Get All Members", new(), Client.GetAll);
        _ = ExecuteClientMethod("Get Member By Id", new { Id = Guid.Empty }, request => Client.GetById(request.Id));
        _ = ExecuteClientMethod("Create Member", new Member(), Client.Create);
        _ = ExecuteClientMethod("Update Member", new { Id = Guid.Empty, Member = new Member() }, 
            request => Client.Update(request.Id, request.Member));
        _ = ExecuteClientMethod("Delete Member", new { Id = Guid.Empty }, request => Client.Delete(request.Id));
    }
} 