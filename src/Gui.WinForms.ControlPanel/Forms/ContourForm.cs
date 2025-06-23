using SevenSeals.Tss.Contour;
using SevenSeals.Tss.Contour.Api;

namespace Gui.WinForms.Forms
{
    public partial class ContourForm : Form
    {
        private readonly IContourClient _client;
        private readonly ISpotClient _spotClient;
        private Spot? _selectedSpot;

        public ContourForm(IContourClient client, ISpotClient spotClient)
        {
            _client = client;
            _spotClient = spotClient;
            InitializeComponent();

            // Set up Swagger link
            swaggerLinkLabel.Text = "Swagger UI";
            swaggerLinkLabel.Click += (s, e) => System.Diagnostics.Process.Start("explorer.exe", GetSwaggerUrl());

            // Wire up button click events
            btnState.Click += async (s, e) => await HandleStateRequest();
            btnLink.Click += async (s, e) => await HandleLinkRequest();
            btnRelayOn.Click += async (s, e) => await HandleRelayOnRequest();
            btnRelayOff.Click += async (s, e) => await HandleRelayOffRequest();

            Load += ContourForm_Load;
            dataGridViewSpots.SelectionChanged += DataGridViewSpots_SelectionChanged;
            UpdateButtonStates();
        }

        private async void ContourForm_Load(object? sender, EventArgs e)
        {
            try
            {
                var spots = await _spotClient.GetAll();
                dataGridViewSpots.DataSource = spots;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading spots: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void DataGridViewSpots_SelectionChanged(object? sender, EventArgs e)
        {
            if (dataGridViewSpots.SelectedRows.Count > 0 && dataGridViewSpots.SelectedRows[0].DataBoundItem is Spot spot)
            {
                _selectedSpot = spot;
                propertyGrid.SelectedObject = spot;
            }
            else
            {
                _selectedSpot = null;
                propertyGrid.SelectedObject = null;
            }
            UpdateButtonStates();
        }

        private void UpdateButtonStates()
        {
            bool hasSpotSelected = _selectedSpot != null;
            btnState.Enabled = hasSpotSelected;
            btnLink.Enabled = hasSpotSelected;
            btnRelayOn.Enabled = hasSpotSelected;
            btnRelayOff.Enabled = hasSpotSelected;
        }

        private ContourRequest CreateBaseSpotRequest()
        {
            if (_selectedSpot == null)
                throw new InvalidOperationException("No spot selected");

            return new ContourRequest
            {
                Options = _selectedSpot.Options,
                Address = _selectedSpot.Addresses[0]
            };
        }

        private async Task HandleStateRequest()
        {
            try
            {
                var request = new StateRequest();
                if (ShowPropertyDialog(request, "State Request") == DialogResult.OK)
                {
                    var response = await _client.State(request);
                    MessageBox.Show(response?.ToString() ?? "No response", "State Response");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error executing state request: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private async Task HandleLinkRequest()
        {
            try
            {
                var request = CreateBaseSpotRequest();
                if (ShowPropertyDialog(request, "Link Request") == DialogResult.OK)
                {
                    var response = await _client.Link(request);
                    MessageBox.Show($"Session ID: {response.SessionId}", "Link Response");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error executing link request: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private async Task HandleRelayOnRequest()
        {
            try
            {
                var request = new RelayOnRequest
                {
                    Options = _selectedSpot!.Options,
                    Address = _selectedSpot.Addresses[0],
                    RelayPort = 1,
                    Interval = 3,
                    SuppressDoorEvent = false,
                    RelayOnAnyKey = false
                };

                if (ShowPropertyDialog(request, "Relay On Request") == DialogResult.OK)
                {
                    var response = await _client.RelayOn(request);
                    MessageBox.Show($"Session ID: {response.SessionId}", "Relay On Response");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error executing relay on request: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private async Task HandleRelayOffRequest()
        {
            try
            {
                var request = new RelayOffRequest
                {
                    Options = _selectedSpot!.Options,
                    Address = _selectedSpot.Addresses[0],
                    RelayPort = 1
                };

                if (ShowPropertyDialog(request, "Relay Off Request") == DialogResult.OK)
                {
                    var response = await _client.RelayOff(request);
                    MessageBox.Show($"Session ID: {response.SessionId}", "Relay Off Response");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error executing relay off request: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private DialogResult ShowPropertyDialog(object request, string title)
        {
            using var dlg = new RequestPropertyDialog(request, title);
            return dlg.ShowDialog(this);
        }

        private string GetSwaggerUrl()
        {
            var baseAddress = _client.Options.BaseUri.TrimEnd('/');
            return $"{baseAddress}/swagger";
        }

        private void btnState_Click(object sender, EventArgs e)
        {
            throw new System.NotImplementedException();
        }
    }
}
