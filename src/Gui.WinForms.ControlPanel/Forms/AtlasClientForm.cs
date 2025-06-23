using SevenSeals.Tss.Atlas;

namespace Gui.WinForms.Forms;

public partial class AtlasClientForm : Form
{
    private readonly IAtlasClient _atlasClient;
    private readonly IZoneClient _zoneClient;
    private readonly ITransitClient _transitClient;
    private Map? _currentMap;
    private List<Zone> _zones = new();
    private List<Transit> _transits = new();
    private readonly HttpClient _httpClient = new();

    public AtlasClientForm(IAtlasClient atlasClient, IZoneClient zoneClient, ITransitClient transitClient)
    {
        _atlasClient = atlasClient;
        _zoneClient = zoneClient;
        _transitClient = transitClient;
        InitializeComponent();
        WireUpEvents();
    }

    public AtlasClientForm()
    {
        InitializeComponent();
        WireUpEvents();
    }

    private void WireUpEvents()
    {
        btnAddZone.Click += btnAddZone_Click;
        btnDeleteZone.Click += btnDeleteZone_Click;
        btnAddTransit.Click += btnAddTransit_Click;
        btnDeleteTransit.Click += btnDeleteTransit_Click;
        btnUpdate.Click += btnUpdate_Click;
        btnRefresh.Click += btnRefresh_Click;
        treeViewZones.AfterSelect += treeViewZones_AfterSelect;
        propertyGrid.PropertyValueChanged += propertyGrid_PropertyValueChanged;
    }

    private async void AtlasClientForm_Load(object sender, EventArgs e)
    {
        await RefreshMap();
        await RefreshPlot();
    }

    private async Task RefreshMap()
    {
        try
        {
            var map = await _atlasClient.Schema();
            _currentMap = map;
            _zones = map.Zones ?? new List<Zone>();
            _transits = map.Transits ?? new List<Transit>();
            BuildZoneTree();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Failed to load map: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }

    private void BuildZoneTree()
    {
        treeViewZones.BeginUpdate();
        treeViewZones.Nodes.Clear();
        var zoneDict = _zones.ToDictionary(z => z.Id);
        var roots = _zones.Where(z => z.ParentId == null).ToList();
        TreeNode? firstNode = null;
        foreach (var root in roots)
        {
            var rootNode = CreateZoneNode(root, zoneDict);
            treeViewZones.Nodes.Add(rootNode);
            if (firstNode == null)
                firstNode = rootNode;
        }
        if (firstNode != null)
            treeViewZones.SelectedNode = firstNode;
        treeViewZones.EndUpdate();
    }

    private TreeNode CreateZoneNode(Zone zone, Dictionary<Guid, Zone> zoneDict)
    {
        var node = new TreeNode(zone.Name ?? zone.Id.ToString()) { Tag = zone };
        var children = _zones.Where(z => z.ParentId == zone.Id).ToList();
        foreach (var child in children)
        {
            node.Nodes.Add(CreateZoneNode(child, zoneDict));
        }
        // Add outgoing transits as child nodes
        var outgoingTransits = _transits.Where(t => t.FromZoneId == zone.Id).ToList();
        foreach (var transit in outgoingTransits)
        {
            var toZone = zoneDict.TryGetValue(transit.ToZoneId, out var z) ? z : null;
            var label = $"→ {(toZone?.Name ?? transit.ToZoneId.ToString())} [{(transit.IsBidirectional ? "↔" : "→")}]";
            var transitNode = new TreeNode(label) { Tag = transit };
            node.Nodes.Add(transitNode);
        }
        return node;
    }

    private void treeViewZones_AfterSelect(object sender, TreeViewEventArgs e)
    {
        if (e.Node?.Tag is Zone zone)
        {
            propertyGrid.SelectedObject = zone;
            propertyGrid.Tag = "zone";
        }
        else if (e.Node?.Tag is Transit transit)
        {
            propertyGrid.SelectedObject = transit;
            propertyGrid.Tag = "transit";
        }
        else
        {
            propertyGrid.SelectedObject = null;
            propertyGrid.Tag = null;
        }
    }

    private Zone? SelectedZone
    {
        get
        {
            if (propertyGrid.SelectedObject is Zone zone)
                return zone;
            if (propertyGrid.SelectedObject is Transit transit)
                return _zones.FirstOrDefault(z => z.Id == transit.FromZoneId);
            // Fallback: select ExternalArea
            return _zones.FirstOrDefault(z => z.Type == ZoneType.ExternalArea);
        }
    }

    private Transit? SelectedTransit
    {
        get
        {
            return propertyGrid.SelectedObject as Transit;
        }
    }

    private async void btnAddZone_Click(object sender, EventArgs e)
    {
        var parentZone = SelectedZone;
        if (parentZone == null || parentZone.Type == ZoneType.ExternalArea)
        {
            MessageBox.Show("Cannot add another External Area zone or add under External Area.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }
        var newZone = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "New Zone",
            IsActive = true,
            ParentId = parentZone.Id
        };
        using var dlg = new RequestPropertyDialog(newZone, "Create Zone");
        if (dlg.ShowDialog(this) == DialogResult.OK)
        {
            await _zoneClient.Add(newZone);
            await RefreshMap();
            await RefreshPlot();
        }
    }

    private async void btnDeleteZone_Click(object sender, EventArgs e)
    {
        var zone = SelectedZone;
        if (zone == null || zone.Type == ZoneType.ExternalArea)
        {
            MessageBox.Show("Cannot delete the External Area zone.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }
        if (MessageBox.Show($"Delete zone '{zone.Name}'?", "Confirm", MessageBoxButtons.YesNo) == DialogResult.Yes)
        {
            await _zoneClient.Delete(zone.Id);
            await RefreshMap();
        }
    }

    private async void btnAddTransit_Click(object sender, EventArgs e)
    {
        var fromZone = SelectedZone;
        if (fromZone == null || fromZone.Type == ZoneType.ExternalArea)
        {
            MessageBox.Show("Cannot add a transit from External Area.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }
        var newTransit = new Transit
        {
            Id = Guid.NewGuid(),
            IsBidirectional = true,
            FromZoneId = fromZone.Id
        };
        using var dlg = new RequestPropertyDialog(newTransit, "Create Transit");
        if (dlg.ShowDialog(this) == DialogResult.OK)
        {
            await _transitClient.Add(newTransit);
            await RefreshMap();
            await RefreshPlot();
        }
    }

    private async void btnDeleteTransit_Click(object sender, EventArgs e)
    {
        if (propertyGrid.SelectedObject is Transit transit && propertyGrid.Tag?.ToString()?.StartsWith("transit") == true)
        {
            if (MessageBox.Show($"Delete transit?", "Confirm", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                await _transitClient.Delete(transit.Id);
                await RefreshMap();
            }
        }
    }

    private async Task RefreshPlot()
    {
        var plot = await _atlasClient.Plot();
        if (string.IsNullOrEmpty(plot.UrlImage))
        {
            pictureBoxPlot.Image = null;
            return;
        }
        var image = await LoadImageFromUrl(plot.UrlImage);
        pictureBoxPlot.Image = image;
    }

    private async Task<Image?> LoadImageFromUrl(string url)
    {
        var bytes = await _httpClient.GetByteArrayAsync(url);
        using var ms = new System.IO.MemoryStream(bytes);
        return Image.FromStream(ms);
    }

    private async void propertyGrid_PropertyValueChanged(object s, PropertyValueChangedEventArgs e)
    {
        // Optionally, auto-apply changes or enable a save button
    }

    protected override async void OnValidated(EventArgs e)
    {
        base.OnValidated(e);
        // Optionally, handle validation
    }

    private void btnRefresh_Click(object sender, EventArgs e)
    {
        _ = RefreshMap();
        _ = RefreshPlot();
    }

    private async void btnUpdate_Click(object sender, EventArgs e)
    {
        if (propertyGrid.SelectedObject is Zone zone && propertyGrid.Tag?.ToString()?.StartsWith("zone") == true)
        {
            await _zoneClient.Update(zone.Id, zone);
            await RefreshMap();
            await RefreshPlot();
            MessageBox.Show("Zone updated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        else if (propertyGrid.SelectedObject is Transit transit && propertyGrid.Tag?.ToString()?.StartsWith("transit") == true)
        {
            await _transitClient.Update(transit.Id, transit);
            await RefreshMap();
            await RefreshPlot();
            MessageBox.Show("Transit updated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        else
        {
            MessageBox.Show("Select a zone or transit to update.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
    }
}
