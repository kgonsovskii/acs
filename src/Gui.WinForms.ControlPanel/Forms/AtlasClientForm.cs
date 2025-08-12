using System.Drawing;
using System.Windows.Forms;
using System.Windows.Forms.VisualStyles;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using SevenSeals.Tss.Atlas;
using SevenSeals.Tss.Shared;

namespace Gui.WinForms.Forms;

public partial class AtlasClientForm : Form
{
    private readonly IAtlasClient _atlasClient;
    private readonly IZoneClient _zoneClient;
    private readonly ITransitClient _transitClient;
    private List<Zone> _zones = new();
    private List<Transit> _transits = new();
    private readonly HttpClient _httpClient = new();
    private string _lastSelectedId = string.Empty;
    private IServiceProvider _serviceProvider;
    private Map? _currentMap;

    public AtlasClientForm(IServiceProvider serviceProvider, IAtlasClient atlasClient, IZoneClient zoneClient, ITransitClient transitClient)
    {
        _serviceProvider = serviceProvider;
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
        btnUp.Click += btnMoveUp_Click;
        btnDown.Click += btnMoveDown_Click;
    }

    private async void AtlasClientForm_Load(object sender, EventArgs e)
    {
        InitializeTreeViewIcons();
        await RefreshMap();
        await RefreshPlot();
    }

    private void InitializeTreeViewIcons()
    {
        // Create ImageList for tree view icons
        var imageList = new ImageList();
        imageList.ImageSize = new Size(16, 16);
        imageList.ColorDepth = ColorDepth.Depth32Bit;

        // Add icons for different zone types
        imageList.Images.Add("ExternalArea", CreateZoneIcon(Color.Green, "🌍"));
        imageList.Images.Add("Building", CreateZoneIcon(Color.Blue, "🏢"));
        imageList.Images.Add("Floor", CreateZoneIcon(Color.Orange, "🏠"));
        imageList.Images.Add("Corridor", CreateZoneIcon(Color.Gray, "🚶"));
        imageList.Images.Add("Room", CreateZoneIcon(Color.LightBlue, "🚪"));
        imageList.Images.Add("Lobby", CreateZoneIcon(Color.Yellow, "🏛️"));
        imageList.Images.Add("Elevator", CreateZoneIcon(Color.Purple, "🛗"));
        imageList.Images.Add("Staircase", CreateZoneIcon(Color.Brown, "🪜"));
        imageList.Images.Add("Parking", CreateZoneIcon(Color.DarkGreen, "🅿️"));
        
        // Add icon for transits
        imageList.Images.Add("Transit", CreateTransitIcon(Color.Red, "➡️"));

        // Configure tree view
        treeViewZones.ImageList = imageList;
        treeViewZones.ItemHeight = 24; // Increase item height
        treeViewZones.ShowLines = true;
        treeViewZones.ShowPlusMinus = true;
        treeViewZones.ShowRootLines = true;
    }

    private Image CreateZoneIcon(Color backgroundColor, string emoji)
    {
        var bitmap = new Bitmap(16, 16);
        using var graphics = Graphics.FromImage(bitmap);
        
        // Fill background
        graphics.Clear(backgroundColor);
        
        // Draw border
        using var pen = new Pen(Color.Black, 1);
        graphics.DrawRectangle(pen, 0, 0, 15, 15);
        
        // Draw emoji (simplified as colored rectangle for now)
        using var brush = new SolidBrush(Color.White);
        graphics.FillRectangle(brush, 3, 3, 10, 10);
        
        return bitmap;
    }

    private Image CreateTransitIcon(Color color, string symbol)
    {
        var bitmap = new Bitmap(16, 16);
        using var graphics = Graphics.FromImage(bitmap);
        
        // Fill background
        graphics.Clear(Color.White);
        
        // Draw arrow symbol
        using var brush = new SolidBrush(color);
        graphics.FillPolygon(brush, new Point[] 
        {
            new Point(2, 8),
            new Point(12, 4),
            new Point(12, 12),
            new Point(2, 8)
        });
        
        return bitmap;
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
            ExpandAllNodes(treeViewZones.Nodes);
            RestoreSelectedId();
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
        var processedZones = new HashSet<Guid>();
        
        var externalArea = _zones.FirstOrDefault(z => z.Type == ZoneType.ExternalArea);
        if (externalArea != null)
        {
            var rootNode = CreateTransitBasedZoneNode(externalArea, zoneDict, processedZones);
            treeViewZones.Nodes.Add(rootNode);
            // Don't automatically select the root node - allow null selection
        }
        
        treeViewZones.EndUpdate();
        ExpandAllNodes(treeViewZones.Nodes);
    }

    private TreeNode CreateTransitBasedZoneNode(Zone zone, Dictionary<Guid, Zone> zoneDict, HashSet<Guid> processedZones)
    {
        var node = new TreeNode(zone.Name ?? zone.Id.ToString()) { Tag = zone };
        
        // Set icon based on zone type
        var iconKey = zone.Type.ToString();
        node.ImageKey = iconKey;
        node.SelectedImageKey = iconKey;
        
        processedZones.Add(zone.Id);
        
        var outgoingTransits = _transits.Where(t => t.FromZoneId == zone.Id).OrderBy(t => t.Order).ToList();
        foreach (var transit in outgoingTransits)
        {
            var toZone = zoneDict.TryGetValue(transit.ToZoneId, out var z) ? z : null;
            if (toZone != null && !processedZones.Contains(toZone.Id))
            {
                var transitName = !string.IsNullOrEmpty(transit.Name) ? transit.Name : (toZone?.Name ?? transit.ToZoneId.ToString());
                var transitNode = new TreeNode(transitName) { Tag = transit };
                
                // Set transit icon
                transitNode.ImageKey = "Transit";
                transitNode.SelectedImageKey = "Transit";
                
                node.Nodes.Add(transitNode);
                
                var toZoneNode = CreateTransitBasedZoneNode(toZone, zoneDict, processedZones);
                transitNode.Nodes.Add(toZoneNode);
            }
        }
        
        var childZones = _zones.Where(z => z.ParentId == zone.Id && !processedZones.Contains(z.Id)).OrderBy(z => z.Order).ToList();
        foreach (var childZone in childZones)
        {
            var childNode = CreateTransitBasedZoneNode(childZone, zoneDict, processedZones);
            node.Nodes.Add(childNode);
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

    private IItem? SelectedItem
    {
        get
        {
           return propertyGrid.SelectedGridItem?.Tag as IItem;
        }
    }

    private Zone? SelectedZone
    {
        get
        {
            if (SelectedItem is Zone zone)
                return zone;
            if (propertyGrid.SelectedObject is Transit transit)
                return _zones.FirstOrDefault(z => z.Id == transit.FromZoneId);
            // No fallback - allow null selection
            return null;
        }
    }

    private Transit? SelectedTransit
    {
        get
        {
            if (propertyGrid.SelectedObject is Transit transit)
                return _transits.FirstOrDefault(z => z.Id == transit.Id);
            return null;
        }
    }

    private async void btnAddZone_Click(object sender, EventArgs e)
    {
        SaveSelectedId();
        
        // Check if a zone is actually selected in the property grid
        if (propertyGrid.SelectedObject is not Zone parentZone || propertyGrid.Tag?.ToString() != "zone")
        {
            MessageBox.Show("Please select a parent zone first.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }
        
        // Allow creating zones in External Area - the validation will handle type restrictions
        var existingZones = _zones.Where(z => z.ParentId == parentZone.Id);
        var maxOrder = existingZones.Any() ? existingZones.Max(z => z.Order) : 0;
        var newZone = new Zone
        {
            Id = Guid.NewGuid(),
            Name = "New Zone",
            IsActive = true,
            ParentId = parentZone.Id,
            Order = maxOrder + 1
        };
        using var dlg = new RequestPropertyDialog(newZone, "Create Zone");
        if (dlg.ShowDialog(this) == DialogResult.OK)
        {
            var (canCreate, createReason) = CanCreateZoneInParent(newZone.Type, parentZone);
            if (!canCreate)
            {
                MessageBox.Show($"Cannot create zone: {createReason}", "Creation Restricted", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            
            await _zoneClient.Add(newZone);
            await RefreshAllAsync();
        }
    }

    private async void btnDeleteZone_Click(object sender, EventArgs e)
    {
        SaveSelectedId();
        
        // Check if a zone is actually selected in the property grid
        if (propertyGrid.SelectedObject is not Zone zone || propertyGrid.Tag?.ToString() != "zone")
        {
            MessageBox.Show("Please select a zone to delete.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }
        
        if (zone.Type == ZoneType.ExternalArea)
        {
            MessageBox.Show("Cannot delete the External Area zone.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }
        
        // Check if zone has children (recursive check)
        var childZones = GetChildZonesRecursive(zone.Id);
        if (childZones.Any())
        {
            var childNames = string.Join(", ", childZones.Take(3).Select(z => z.Name));
            if (childZones.Count > 3)
                childNames += $" and {childZones.Count - 3} more";
            
            MessageBox.Show($"Cannot delete zone '{zone.Name}' because it has child zones: {childNames}. Please delete child zones first.", "Cannot Delete", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }
        
        if (MessageBox.Show($"Delete zone '{zone.Name}'?", "Confirm", MessageBoxButtons.YesNo) == DialogResult.Yes)
        {
            // Find the best item to select after deletion
            var nextItemToSelect = FindNextItemToSelectAfterZoneDeletion(zone);
            _lastSelectedId = nextItemToSelect?.GetId();
            
            await _zoneClient.Delete(zone.Id);
            await RefreshAllAsync();
        }
    }

    private async void btnAddTransit_Click(object sender, EventArgs e)
    {
        SaveSelectedId();
        
        // Check if a zone is actually selected in the property grid
        if (propertyGrid.SelectedObject is not Zone fromZone || propertyGrid.Tag?.ToString() != "zone")
        {
            MessageBox.Show("Please select a source zone first.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }
        
        // Allow creating transits from External Area - this makes sense for external connections
        var existingTransits = _transits.Where(t => t.FromZoneId == fromZone.Id);
        var maxOrder = existingTransits.Any() ? existingTransits.Max(t => t.Order) : 0;
        var newTransit = new Transit
        {
            Id = Guid.NewGuid(),
            IsBidirectional = true,
            FromZoneId = fromZone.Id,
            Order = maxOrder + 1
        };
        using var dlg = new RequestPropertyDialog(newTransit, "Create Transit");
        if (dlg.ShowDialog(this) == DialogResult.OK)
        {
            await _transitClient.Add(newTransit);
            await RefreshAllAsync();
        }
    }

    private async void btnDeleteTransit_Click(object sender, EventArgs e)
    {
        SaveSelectedId();
        if (propertyGrid.SelectedObject is Transit transit && propertyGrid.Tag?.ToString()?.StartsWith("transit") == true)
        {
            // Check if deleting this transit will orphan any zones
            var orphanedZones = GetOrphanedZonesAfterTransitDeletion(transit);
            if (orphanedZones.Any())
            {
                var zoneNames = string.Join(", ", orphanedZones.Take(3).Select(z => z.Name));
                if (orphanedZones.Count > 3)
                    zoneNames += $" and {orphanedZones.Count - 3} more";
                
                var result = MessageBox.Show($"Deleting this transit will orphan the following zones: {zoneNames}. Do you want to continue?", "Orphaned Zones Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
                if (result != DialogResult.Yes)
                    return;
            }
            
            if (MessageBox.Show($"Delete transit?", "Confirm", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                // Find the best item to select after deletion
                var nextItemToSelect = FindNextItemToSelectAfterTransitDeletion(transit);
                _lastSelectedId = nextItemToSelect?.GetId();
                
                await _transitClient.Delete(transit.Id);
                await RefreshAllAsync();
            }
        }
    }

    private async Task RefreshPlot()
    {
        try
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
        catch (Exception ex)
        {
            // Create error image with text instead of showing MessageBox
            pictureBoxPlot.Image = CreateErrorImage($"Failed to load plot image:\n{ex.Message}");
        }
    }

    private Image CreateErrorImage(string errorMessage)
    {
        // Create a simple error image with text
        var width = pictureBoxPlot.Width > 0 ? pictureBoxPlot.Width : 400;
        var height = pictureBoxPlot.Height > 0 ? pictureBoxPlot.Height : 300;
        
        var bitmap = new Bitmap(width, height);
        using var graphics = Graphics.FromImage(bitmap);
        
        // Fill background with light red
        graphics.Clear(Color.MistyRose);
        
        // Draw border
        using var borderPen = new Pen(Color.Red, 2);
        graphics.DrawRectangle(borderPen, 1, 1, width - 2, height - 2);
        
        // Draw error icon (simple X)
        using var iconPen = new Pen(Color.Red, 3);
        var iconSize = 40;
        var iconX = 20;
        var iconY = 20;
        graphics.DrawLine(iconPen, iconX, iconY, iconX + iconSize, iconY + iconSize);
        graphics.DrawLine(iconPen, iconX + iconSize, iconY, iconX, iconY + iconSize);
        
        // Draw error text
        using var font = new Font("Arial", 10, FontStyle.Regular);
        using var brush = new SolidBrush(Color.DarkRed);
        var textRect = new Rectangle(80, 20, width - 100, height - 40);
        graphics.DrawString(errorMessage, font, brush, textRect);
        
        return bitmap;
    }

    private async Task<Image?> LoadImageFromUrl(string url)
    {
        try
        {
            var bytes = await _httpClient.GetByteArrayAsync(url);
            using var ms = new System.IO.MemoryStream(bytes);
            return Image.FromStream(ms);
        }
        catch (HttpRequestException ex)
        {
            // Handle HTTP errors (like 520 from PlantUML server)
            throw new Exception($"PlantUML server error: {ex.StatusCode} - {ex.Message}");
        }
        catch (Exception ex)
        {
            // Handle other errors
            throw new Exception($"Failed to load image from URL: {ex.Message}");
        }
    }

    private async void propertyGrid_PropertyValueChanged(object s, PropertyValueChangedEventArgs e)
    {
        if (e.ChangedItem?.PropertyDescriptor?.Name == "Order")
        {
            await RefreshAllAsync();
        }
    }

    protected override async void OnValidated(EventArgs e)
    {
        base.OnValidated(e);
        // Optionally, handle validation
    }

    private async void btnRefresh_Click(object sender, EventArgs e)
    {
        await RefreshAllAsync();
    }

    private async void btnUpdate_Click(object sender, EventArgs e)
    {
        SaveSelectedId();
        if (propertyGrid.SelectedObject is Zone zone && propertyGrid.Tag?.ToString()?.StartsWith("zone") == true)
        {
            await _zoneClient.Update(zone.Id, zone);
            await RefreshAllAsync();
            MessageBox.Show("Zone updated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        else if (propertyGrid.SelectedObject is Transit transit &&
                 propertyGrid.Tag?.ToString()?.StartsWith("transit") == true)
        {
            await _transitClient.Update(transit.Id, transit);
            await RefreshAllAsync();
            MessageBox.Show("Transit updated successfully.", "Success", MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }
        else
        {
            MessageBox.Show("Select a zone or transit to update.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        await RefreshAllAsync();
    }

    // Handler for UP button
    private void btnMoveUp_Click(object sender, EventArgs e)
    {
        MoveSelectedZone(-1);
    }
    // Handler for DOWN button
    private void btnMoveDown_Click(object sender, EventArgs e)
    {
        MoveSelectedZone(1);
    }
    private async void MoveSelectedZone(int direction)
    {
        var selectedNode = treeViewZones.SelectedNode;
        if (selectedNode == null) return;
        
        var parentNode = selectedNode.Parent;
        if (parentNode == null) return;
        
        var siblings = parentNode.Nodes.Cast<TreeNode>().ToList();
        int currentIndex = siblings.IndexOf(selectedNode);
        int newIndex = currentIndex + direction;
        
        if (newIndex < 0 || newIndex >= siblings.Count) return;
        
        var targetNode = siblings[newIndex];
        
        if (selectedNode.Tag is Zone selectedZone && targetNode.Tag is Zone targetZone)
        {
            if (selectedZone.ParentId == targetZone.ParentId)
            {
                var (canSwap, swapReason) = CanSwapZonePositions(selectedZone, targetZone);
                if (canSwap)
                {
                    SwapZoneOrder(selectedZone, targetZone);
                }
                else
                {
                    MessageBox.Show($"Cannot swap positions: {swapReason}", "Move Restricted", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }
            }
            else
            {
                var (canMove, moveReason) = CanMoveZoneToParent(selectedZone, targetZone);
                if (canMove)
                {
                    MoveZoneToNewParent(selectedZone, targetZone);
                }
                else
                {
                    MessageBox.Show($"Cannot move zone: {moveReason}", "Move Restricted", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }
            }
        }
        else if (selectedNode.Tag is Transit selectedTransit && targetNode.Tag is Transit targetTransit)
        {
            if (selectedTransit.FromZoneId == targetTransit.FromZoneId)
            {
                SwapTransitOrder(selectedTransit, targetTransit);
            }
        }
        
        await RefreshAllAsync();
    }
    
    private void MoveZoneToNewParent(Zone zone, Zone newParent)
    {
        var oldParentId = zone.ParentId;
        zone.ParentId = newParent.Id;
        
        var existingZones = _zones.Where(z => z.ParentId == newParent.Id);
        var maxOrder = existingZones.Any() ? existingZones.Max(z => z.Order) : 0;
        zone.Order = maxOrder + 1;
    }
    
    private void SwapZoneOrder(Zone zone1, Zone zone2)
    {
        var tempOrder = zone1.Order;
        zone1.Order = zone2.Order;
        zone2.Order = tempOrder;
    }
    
    private void SwapTransitOrder(Transit transit1, Transit transit2)
    {
        var tempOrder = transit1.Order;
        transit1.Order = transit2.Order;
        transit2.Order = tempOrder;
    }
    
    private (bool canMove, string reason) CanMoveZoneToParent(Zone zone, Zone? newParent)
    {
        if (zone.Type == ZoneType.ExternalArea)
            return (false, "External Area zones cannot be moved.");
            
        if (newParent == null)
        {
            if (zone.Type == ZoneType.Building)
                return (true, "");
            return (false, $"Only Building zones can be root zones. Cannot move {zone.Type} to root level.");
        }
            
        if (newParent.Type == ZoneType.ExternalArea)
            return (false, "Cannot move zones into External Area.");
            
        switch (zone.Type)
        {
            case ZoneType.Building:
                if (newParent.Type == ZoneType.ExternalArea)
                    return (true, "");
                return (false, $"Building zones can only be moved to External Area, not to {newParent.Type}.");
            case ZoneType.Floor:
                if (newParent.Type == ZoneType.Building)
                    return (true, "");
                return (false, $"Floor zones can only be moved to Building zones, not to {newParent.Type}.");
            case ZoneType.Room:
            case ZoneType.Corridor:
            case ZoneType.Lobby:
            case ZoneType.Elevator:
            case ZoneType.Staircase:
                if (newParent.Type == ZoneType.Floor)
                    return (true, "");
                return (false, $"{zone.Type} zones can only be moved to Floor zones, not to {newParent.Type}.");
            case ZoneType.Parking:
                if (newParent.Type == ZoneType.Building || newParent.Type == ZoneType.ExternalArea)
                    return (true, "");
                return (false, $"Parking zones can only be moved to Building or External Area zones, not to {newParent.Type}.");
            default:
                return (true, "");
        }
    }
    
    private (bool canSwap, string reason) CanSwapZonePositions(Zone zone1, Zone zone2)
    {
        if (zone1.ParentId != zone2.ParentId)
            return (false, "Cannot swap positions of zones with different parents.");
            
        if (zone1.Type == ZoneType.ExternalArea || zone2.Type == ZoneType.ExternalArea)
            return (false, "External Area zones cannot have their positions swapped.");
            
        return (true, "");
    }
    
    private (bool canCreate, string reason) CanCreateZoneInParent(ZoneType zoneType, Zone? parentZone)
    {
        if (zoneType == ZoneType.ExternalArea)
            return (false, "External Area zones cannot be created manually.");
            
        if (parentZone == null)
        {
            if (zoneType == ZoneType.Building)
                return (true, "");
            return (false, $"Only Building zones can be created at root level. Cannot create {zoneType} without a parent.");
        }
            
        // External Area can contain Building and Parking zones
        if (parentZone.Type == ZoneType.ExternalArea)
        {
            if (zoneType == ZoneType.Building || zoneType == ZoneType.Parking)
                return (true, "");
            return (false, $"Only Building and Parking zones can be created under External Area. Cannot create {zoneType}.");
        }
            
        switch (zoneType)
        {
            case ZoneType.Building:
                if (parentZone.Type == ZoneType.ExternalArea)
                    return (true, "");
                return (false, $"Building zones can only be created under External Area, not under {parentZone.Type}.");
            case ZoneType.Floor:
                if (parentZone.Type == ZoneType.Building)
                    return (true, "");
                return (false, $"Floor zones can only be created under Building zones, not under {parentZone.Type}.");
            case ZoneType.Room:
            case ZoneType.Corridor:
            case ZoneType.Lobby:
            case ZoneType.Elevator:
            case ZoneType.Staircase:
                if (parentZone.Type == ZoneType.Floor)
                    return (true, "");
                return (false, $"{zoneType} zones can only be created under Floor zones, not under {parentZone.Type}.");
            case ZoneType.Parking:
                if (parentZone.Type == ZoneType.Building || parentZone.Type == ZoneType.ExternalArea)
                    return (true, "");
                return (false, $"Parking zones can only be created under Building or External Area zones, not under {parentZone.Type}.");
            default:
                return (true, "");
        }
    }
    private void SaveSelectedId()
    {
        if (propertyGrid.SelectedObject is IItem item)
        {
            _lastSelectedId = item.GetId();
        }
    }
    private void RestoreSelectedId()
    {
        if (string.IsNullOrEmpty(_lastSelectedId))
        {
            // If no previous selection, select the root (External Area)
            var externalAreaNode = FindExternalAreaNode(treeViewZones.Nodes);
            if (externalAreaNode != null)
            {
                // Set the selected node directly (like in the Stack Overflow solution)
                treeViewZones.SelectedNode = externalAreaNode;
                externalAreaNode.EnsureVisible();
                
                if (externalAreaNode.Tag is Zone zone)
                {
                    propertyGrid.SelectedObject = zone;
                    propertyGrid.Tag = "zone";
                    _lastSelectedId = zone.GetId(); // Save the selection
                }
            }
            return;
        }
        
        if (Guid.TryParse(_lastSelectedId, out var id))
        {
            var node = FindNodeByZoneId(treeViewZones.Nodes, id);
            if (node != null)
            {
                // Set the selected node directly (like in the Stack Overflow solution)
                treeViewZones.SelectedNode = node;
                node.EnsureVisible();

                // Also update the property grid to show the selected item
                if (node.Tag is Zone zone)
                {
                    propertyGrid.SelectedObject = zone;
                    propertyGrid.Tag = "zone";
                }
                else if (node.Tag is Transit transit)
                {
                    propertyGrid.SelectedObject = transit;
                    propertyGrid.Tag = "transit";
                }
            }
            else
            {
                // If the previously selected item no longer exists, select the root
                var externalAreaNode = FindExternalAreaNode(treeViewZones.Nodes);
                if (externalAreaNode != null)
                {
                    // Set the selected node directly (like in the Stack Overflow solution)
                    treeViewZones.SelectedNode = externalAreaNode;
                    externalAreaNode.EnsureVisible();
                    
                    if (externalAreaNode.Tag is Zone zone)
                    {
                        propertyGrid.SelectedObject = zone;
                        propertyGrid.Tag = "zone";
                        _lastSelectedId = zone.GetId();
                    }
                }
                else
                {
                    // Clear selection if even root is not found
                    treeViewZones.SelectedNode = null;
                    propertyGrid.SelectedObject = null;
                    propertyGrid.Tag = null;
                    _lastSelectedId = null;
                }
            }
        }
    }
    
    private async Task RefreshAllAsync()
    {
        SaveSelectedId();
        await RefreshMap();
        BuildZoneTree();
        ExpandAllNodes(treeViewZones.Nodes);
        RestoreSelectedId();
        await RefreshPlot();
    }

    private TreeNode? FindNodeByZoneId(TreeNodeCollection nodes, Guid id)
    {
        foreach (TreeNode node in nodes)
        {
            if (node.Tag is Zone z && z.Id == id)
                return node;
            if (node.Tag is Transit t && t.Id == id)
                return node;
            var found = FindNodeByZoneId(node.Nodes, id);
            if (found != null) return found;
        }
        return null;
    }

    private TreeNode? FindExternalAreaNode(TreeNodeCollection nodes)
    {
        foreach (TreeNode node in nodes)
        {
            if (node.Tag is Zone zone && zone.Type == ZoneType.ExternalArea)
                return node;
            var found = FindExternalAreaNode(node.Nodes);
            if (found != null) return found;
        }
        return null;
    }
    private void ExpandAllNodes(TreeNodeCollection nodes)
    {
        foreach (TreeNode node in nodes)
        {
            node.Expand();
            ExpandAllNodes(node.Nodes);
        }
    }

    private IItem? FindNextItemToSelectAfterZoneDeletion(Zone deletedZone)
    {
        // Priority order for selection after zone deletion:
        // 1. Next sibling zone (same parent, higher order)
        // 2. Previous sibling zone (same parent, lower order)
        // 3. Parent zone
        // 4. First child zone (if any)
        // 5. Any sibling zone (only if parent exists)
        // 6. External Area (fallback)

        if (deletedZone.ParentId.HasValue)
        {
            var parentZone = _zones.FirstOrDefault(z => z.Id == deletedZone.ParentId.Value);
            if (parentZone != null)
            {
                // 1. Try to find next sibling
                var nextSibling = _zones
                    .Where(z => z.ParentId == deletedZone.ParentId && z.Order > deletedZone.Order)
                    .OrderBy(z => z.Order)
                    .FirstOrDefault();
                if (nextSibling != null)
                    return nextSibling;

                // 2. Try to find previous sibling
                var prevSibling = _zones
                    .Where(z => z.ParentId == deletedZone.ParentId && z.Order < deletedZone.Order)
                    .OrderByDescending(z => z.Order)
                    .FirstOrDefault();
                if (prevSibling != null)
                    return prevSibling;

                // 3. Select parent zone
                return parentZone;
            }
        }

        // 4. Try to find first child of the deleted zone (if any)
        var firstChild = _zones
            .Where(z => z.ParentId == deletedZone.Id)
            .OrderBy(z => z.Order)
            .FirstOrDefault();
        if (firstChild != null)
            return firstChild;

        // 5. Try to find any sibling zone (only if parent exists)
        if (deletedZone.ParentId.HasValue)
        {
            var anySibling = _zones
                .Where(z => z.ParentId == deletedZone.ParentId && z.Id != deletedZone.Id)
                .OrderBy(z => z.Order)
                .FirstOrDefault();
            if (anySibling != null)
                return anySibling;
        }

        // 6. Fallback to External Area (Outside world)
        return _zones.FirstOrDefault(z => z.Type == ZoneType.ExternalArea);
    }

    private IItem? FindNextItemToSelectAfterTransitDeletion(Transit deletedTransit)
    {
        // Priority order for selection after transit deletion:
        // 1. Next transit from the same source zone
        // 2. Previous transit from the same source zone
        // 3. Source zone
        // 4. Target zone
        // 5. Any transit from the same source zone
        // 6. External Area (fallback)

        // 1. Try to find next transit from same source
        var nextTransit = _transits
            .Where(t => t.FromZoneId == deletedTransit.FromZoneId && t.Order > deletedTransit.Order)
            .OrderBy(t => t.Order)
            .FirstOrDefault();
        if (nextTransit != null)
            return nextTransit;

        // 2. Try to find previous transit from same source
        var prevTransit = _transits
            .Where(t => t.FromZoneId == deletedTransit.FromZoneId && t.Order < deletedTransit.Order)
            .OrderByDescending(t => t.Order)
            .FirstOrDefault();
        if (prevTransit != null)
            return prevTransit;

        // 3. Select source zone
        var sourceZone = _zones.FirstOrDefault(z => z.Id == deletedTransit.FromZoneId);
        if (sourceZone != null)
            return sourceZone;

        // 4. Select target zone
        var targetZone = _zones.FirstOrDefault(z => z.Id == deletedTransit.ToZoneId);
        if (targetZone != null)
            return targetZone;

        // 5. Try to find any transit from the same source zone
        var anyTransit = _transits
            .Where(t => t.FromZoneId == deletedTransit.FromZoneId && t.Id != deletedTransit.Id)
            .OrderBy(t => t.Order)
            .FirstOrDefault();
        if (anyTransit != null)
            return anyTransit;

        // 6. Fallback to External Area
        return _zones.FirstOrDefault(z => z.Type == ZoneType.ExternalArea);
    }

    private List<Zone> GetOrphanedZonesAfterTransitDeletion(Transit transit)
    {
        var orphanedZones = new List<Zone>();
        
        // Check if the target zone would become orphaned
        var targetZone = _zones.FirstOrDefault(z => z.Id == transit.ToZoneId);
        if (targetZone != null)
        {
            // Check if this transit is the only connection to the target zone
            var otherTransitsToTarget = _transits
                .Where(t => t.Id != transit.Id && 
                           (t.FromZoneId == targetZone.Id || t.ToZoneId == targetZone.Id))
                .ToList();
            
            // Also check if target zone has a parent (implicit connection)
            var hasParent = targetZone.ParentId.HasValue;
            
            // If no other transits and no parent, the zone would be orphaned
            if (!otherTransitsToTarget.Any() && !hasParent)
            {
                orphanedZones.Add(targetZone);
            }
        }
        
        return orphanedZones;
    }

    private List<Zone> GetChildZonesRecursive(Guid parentZoneId)
    {
        var result = new List<Zone>();
        var directChildren = _zones.Where(z => z.ParentId == parentZoneId).ToList();
        
        foreach (var child in directChildren)
        {
            result.Add(child);
            // Recursively get children of children
            result.AddRange(GetChildZonesRecursive(child.Id));
        }
        
        return result;
    }

    private async void btnSaveAll_Click(object sender, EventArgs e)
    {
        using var scope = _serviceProvider.CreateScope();
        var settings = scope.ServiceProvider.GetRequiredService<Settings>();
        var transits = await _transitClient.GetAll();
        var zones = await _zoneClient.GetAll();

        var saveType = settings.StorageType;
        try
        {
            settings.StorageType = StorageType.Json;
            settings.DataDir = DbSharedToolFolder;

            var transitStorage = scope.ServiceProvider.GetRequiredService<ITransitStorage>();
            transitStorage.SetAll(transits);

            var zoneStorage = scope.ServiceProvider.GetRequiredService<IZoneStorage>();
            zoneStorage.SetAll(zones);
        }
        finally
        {
            settings.StorageType = saveType;
        }
    }

    private string? DbSharedToolFolder
    {
        get
        {
            var dir = new DirectoryInfo(Directory.GetCurrentDirectory());
            while (dir != null)
            {
                var candidate = Path.Combine(dir.FullName, "src", "Shared.Db.Tool", "initdata");
                if (Directory.Exists(candidate))
                    return candidate;
                // Also check without "src" in case structure is different
                candidate = Path.Combine(dir.FullName, "Shared.Db.Tool");
                if (Directory.Exists(candidate))
                    return candidate;
                dir = dir.Parent;
            }
            return null; // Not found
        }
    }
}
