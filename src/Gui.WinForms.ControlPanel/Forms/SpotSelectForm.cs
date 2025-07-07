using SevenSeals.Tss.Contour;

namespace Gui.WinForms.Forms;

public class SpotSelectForm : Form
{
    private readonly ISpotClient _spotClient;
    private readonly DataGridView _dataGridView;
    private readonly Button _okButton;
    private readonly Button _cancelButton;
    private IList<Spot> _spots = new List<Spot>();
    public Spot? SelectedSpot { get; private set; }

    public SpotSelectForm(ISpotClient spotClient)
    {
        _spotClient = spotClient;
        Text = "Select Spot";
        Width = 600;
        Height = 400;
        StartPosition = FormStartPosition.CenterParent;

        _dataGridView = new DataGridView
        {
            Dock = DockStyle.Top,
            Height = 300,
            ReadOnly = true,
            SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            AutoGenerateColumns = true
        };
        Controls.Add(_dataGridView);

        var buttonPanel = new FlowLayoutPanel { Dock = DockStyle.Bottom, FlowDirection = FlowDirection.RightToLeft, Height = 40 };
        _okButton = new Button { Text = "OK", Width = 100 };
        _cancelButton = new Button { Text = "Cancel", Width = 100 };
        buttonPanel.Controls.Add(_okButton);
        buttonPanel.Controls.Add(_cancelButton);
        Controls.Add(buttonPanel);

        _okButton.Click += (s, e) =>
        {
            if (_dataGridView.SelectedRows.Count > 0)
            {
                var idx = _dataGridView.SelectedRows[0].Index;
                SelectedSpot = _spots[idx];
                DialogResult = DialogResult.OK;
                Close();
            }
            else
            {
                MessageBox.Show("Please select a spot.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        };
        _cancelButton.Click += (s, e) => { DialogResult = DialogResult.Cancel; Close(); };

        Load += async (s, e) => await LoadSpots();
    }

    private async Task LoadSpots()
    {
        try
        {
            _spots = await _spotClient.GetAll();
            _dataGridView.DataSource = _spots;
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Failed to load spots: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }
} 