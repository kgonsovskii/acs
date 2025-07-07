using SevenSeals.Tss.Actor;
using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Contour.Api;

namespace Gui.WinForms.Forms;

public partial class PassClientForm : StorageForm<Pass, Guid, IPassClient>
{
    private readonly IContourClient _contourClient;
    private readonly ISpotClient _spotClient;

    public PassClientForm(IPassClient client, IContourClient contourClient, ISpotClient spotClient) : base(client, "Pass Management")
    {
        _contourClient = contourClient;
        _spotClient = spotClient;
        var addByContourButton = new Button { Text = "Add by Contour", Width = 180, Height = 30 };
        addByContourButton.Click += async (s, e) =>
        {
            try
            {
                using var spotForm = new SpotSelectForm(_spotClient);
                if (spotForm.ShowDialog(this) != DialogResult.OK || spotForm.SelectedSpot == null)
                    return;
                var selectedSpot = spotForm.SelectedSpot;
                var key = await _contourClient.WaitForPass(new WaitForPassRequest()
                {
                    Address = selectedSpot.Addresses.First(),
                    Options = selectedSpot.Options
                });
                if (!string.IsNullOrEmpty(key.KeyNumber))
                {
                    var newPass = new Pass
                    {
                        KeyNumber = key.KeyNumber,
                        IsActive = true
                    };
                    await _client.Add(newPass);
                    await GetAllItems();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        };
        AddCustomButton(addByContourButton);
    }
}
