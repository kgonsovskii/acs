using Actor.Client;
using Actor.Model;
using SevenSeals.Tss.Actor;

namespace Gui.ControlPanel.WinForms.Forms;

public class PassClientForm : BaseClientForm<PassClient>
{
    public PassClientForm(PassClient client) : base(client)
    {
        Text = "Pass Client";
        InitializeButtons();
    }

    private void InitializeButtons()
    {
        // Add buttons for each PassClient method
        _ = ExecuteClientMethod("Get All Passes", new(), Client.GetAll);
        _ = ExecuteClientMethod("Get Pass By Id", new { Id = Guid.Empty }, request => Client.GetById(request.Id));
        _ = ExecuteClientMethod("Create Pass", new Pass(), Client.Create);
        _ = ExecuteClientMethod("Update Pass", new { Id = Guid.Empty, Pass = new Pass() }, 
            request => Client.Update(request.Id, request.Pass));
        _ = ExecuteClientMethod("Delete Pass", new { Id = Guid.Empty }, request => Client.Delete(request.Id));
    }
} 