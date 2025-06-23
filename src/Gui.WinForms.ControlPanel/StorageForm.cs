using SevenSeals.Tss.Shared;
using Infra;

namespace Gui.WinForms;

public class StorageForm<TItem, TId, TClient> : Form
    where TClient : IProtoStorageClient<TItem, TItem, TId>
    where TItem : IItem<TId>, IProtoRequest, IProtoResponse
{
    protected readonly TClient _client;
    private readonly Panel _contentPanel;
    private readonly Button _getAllButton;
    private readonly Button _getByIdButton;
    private readonly Button _createButton;
    private readonly Button _updateButton;
    private readonly Button _deleteButton;
    private readonly Button _getByFieldButton;
    private readonly Button _getByFieldsButton;
    private readonly Button _getByWhereButton;
    private readonly Button _getFirstByFieldButton;
    private readonly Button _existsByFieldButton;
    private readonly FlowLayoutPanel _buttonsPanel;
    private readonly TableLayoutPanel _mainLayout;
    private readonly TableLayoutPanel _leftPanelLayout;
    private readonly PropertyGrid _propertyGrid;
    private readonly FlowLayoutPanel _rightButtonPanel;
    private readonly DataGridView _dataGridView;
    private readonly Panel _topPanel;
    private readonly LinkLabel _swaggerLinkLabel;
    private readonly TableLayoutPanel _rootLayout;


    public StorageForm()
    {
    }
    protected StorageForm(TClient client, string title = "Storage Management")
    {
        _client = client;
        Text = title;
        Width = 1020;
        Height = 600;

        // Root layout: 2 rows (top panel, main content)
        _rootLayout = new TableLayoutPanel { RowCount = 2, ColumnCount = 1, Dock = DockStyle.Fill };
        _rootLayout.RowStyles.Add(new RowStyle(SizeType.Absolute, 36F)); // Top panel
        _rootLayout.RowStyles.Add(new RowStyle(SizeType.Percent, 100F)); // Main content
        _rootLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100F));

        // Top panel with Swagger link
        _topPanel = new Panel { Height = 32, Dock = DockStyle.Fill };
        _swaggerLinkLabel = new LinkLabel { Text = "Open Swagger UI", AutoSize = true, Top = 8, Left = 8 };
        _swaggerLinkLabel.LinkClicked += (s, e) => OpenSwaggerInBrowser();
        _topPanel.Controls.Add(_swaggerLinkLabel);
        _rootLayout.Controls.Add(_topPanel, 0, 0);

        _mainLayout = new TableLayoutPanel { ColumnCount = 3, Dock = DockStyle.Fill };
        _mainLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 200F)); // Left: buttons
        _mainLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 60F));   // Center: grid
        _mainLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 40F));   // Right: property grid

        _leftPanelLayout = new TableLayoutPanel { ColumnCount = 1, Dock = DockStyle.Fill };
        _leftPanelLayout.RowCount = 2;
        _leftPanelLayout.RowStyles.Add(new RowStyle(SizeType.Absolute, 180F));
        _leftPanelLayout.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));

        _buttonsPanel = new FlowLayoutPanel
        {
            AutoScroll = true,
            Dock = DockStyle.Fill,
            FlowDirection = FlowDirection.TopDown,
            WrapContents = false
        };

        _getAllButton = new Button { Text = $"Get All {typeof(TItem).Name}s", Width = 180, Height = 30 };
        _getByIdButton = new Button { Text = $"Get {typeof(TItem).Name} by ID", Width = 180, Height = 30 };
        _createButton = new Button { Text = $"Create {typeof(TItem).Name}", Width = 180, Height = 30 };
        _updateButton = new Button { Text = $"Update {typeof(TItem).Name}", Width = 180, Height = 30 };
        _deleteButton = new Button { Text = $"Delete {typeof(TItem).Name}", Width = 180, Height = 30 };

        // Add search buttons
        _getByFieldButton = new Button { Text = "Search by Field", Width = 180, Height = 30 };
        _getByFieldsButton = new Button { Text = "Search by Fields", Width = 180, Height = 30 };
        _getByWhereButton = new Button { Text = "Search by Where", Width = 180, Height = 30 };
        _getFirstByFieldButton = new Button { Text = "Get First by Field", Width = 180, Height = 30 };
        _existsByFieldButton = new Button { Text = "Exists by Field", Width = 180, Height = 30 };

        _buttonsPanel.Controls.Add(_getAllButton);
        _buttonsPanel.Controls.Add(_getByIdButton);
        _buttonsPanel.Controls.Add(_createButton);
        _buttonsPanel.Controls.Add(_updateButton);
        _buttonsPanel.Controls.Add(_deleteButton);

        // Add separator
        var separator = new Label { Text = "Search Operations:", Width = 180, Height = 20 };
        separator.Font = new Font(separator.Font, FontStyle.Bold);
        _buttonsPanel.Controls.Add(separator);

        // Add search buttons
        _buttonsPanel.Controls.Add(_getByFieldButton);
        _buttonsPanel.Controls.Add(_getByFieldsButton);
        _buttonsPanel.Controls.Add(_getByWhereButton);
        _buttonsPanel.Controls.Add(_getFirstByFieldButton);
        _buttonsPanel.Controls.Add(_existsByFieldButton);

        _leftPanelLayout.Controls.Add(_buttonsPanel, 0, 1);

        // Center: DataGridView
        _dataGridView = new DataGridView { Dock = DockStyle.Fill, ReadOnly = true, SelectionMode = DataGridViewSelectionMode.FullRowSelect, AutoGenerateColumns = true };
        _dataGridView.SelectionChanged += DataGridView_SelectionChanged;

        // Right: PropertyGrid and Update button
        var rightPanel = new TableLayoutPanel { RowCount = 2, Dock = DockStyle.Fill };
        rightPanel.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
        rightPanel.RowStyles.Add(new RowStyle(SizeType.Absolute, 48F));
        _propertyGrid = new PropertyGrid { Dock = DockStyle.Fill };
        _rightButtonPanel = new FlowLayoutPanel { Dock = DockStyle.Fill, FlowDirection = FlowDirection.LeftToRight, Height = 48 };
        var updateButton = new Button { Text = $"Update {typeof(TItem).Name}", Width = 180, Height = 30 };
        updateButton.Click += async (s, e) => await UpdateItem();
        _rightButtonPanel.Controls.Add(updateButton);
        rightPanel.Controls.Add(_propertyGrid, 0, 0);
        rightPanel.Controls.Add(_rightButtonPanel, 0, 1);

        _mainLayout.Controls.Add(_leftPanelLayout, 0, 0);
        _mainLayout.Controls.Add(_dataGridView, 1, 0);
        _mainLayout.Controls.Add(rightPanel, 2, 0);
        _rootLayout.Controls.Add(_mainLayout, 0, 1);
        Controls.Add(_rootLayout);

        _getAllButton.Click += async (s, e) => await GetAllItems();
        _getByIdButton.Click += async (s, e) => await GetById();
        _createButton.Click += async (s, e) => await CreateItem();
        _updateButton.Click += async (s, e) => await UpdateItem();
        _deleteButton.Click += async (s, e) => await DeleteItem();

        // Add search button event handlers
        _getByFieldButton.Click += async (s, e) => await GetByField();
        _getByFieldsButton.Click += async (s, e) => await GetByFields();
        _getByWhereButton.Click += async (s, e) => await GetByWhere();
        _getFirstByFieldButton.Click += async (s, e) => await GetFirstByField();
        _existsByFieldButton.Click += async (s, e) => await ExistsByField();
    }

    private void DataGridView_SelectionChanged(object? sender, EventArgs e)
    {
        try
        {
            if (_dataGridView.SelectedRows.Count > 0 && _dataGridView.DataSource is ItemDataTable<TItem> table)
            {
                var item = table.GetItem(_dataGridView.SelectedRows[0].Index);
                _propertyGrid.SelectedObject = item;
            }
            else
            {
                _propertyGrid.SelectedObject = null;
            }
        }
        catch (Exception exception)
        {
        }
    }

    protected virtual async Task GetAllItems()
    {
        try
        {
            _getAllButton.Enabled = false;
            var items = await _client.GetAll();
            DisplayItems(items);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            _getAllButton.Enabled = true;
        }
    }

    protected virtual async Task GetById()
    {
        var request = new GetByIdRequest<TId>();
        using (var dlg = new RequestPropertyDialog(request, $"Get {typeof(TItem).Name} by ID"))
        {
            if (dlg.ShowDialog(this) != DialogResult.OK)
                return;
        }
        try
        {
            _getByIdButton.Enabled = false;
            var item = await _client.GetById(request.Id);
            if (item != null)
                DisplayItems(new List<TItem> { item });
            else
                MessageBox.Show($"{typeof(TItem).Name} not found", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            _getByIdButton.Enabled = true;
        }
    }

    protected virtual async Task CreateItem()
    {
        var item = Activator.CreateInstance<TItem>();
        using (var dlg = new RequestPropertyDialog(item!, $"Create {typeof(TItem).Name}"))
        {
            if (dlg.ShowDialog(this) != DialogResult.OK)
                return;
        }
        try
        {
            _createButton.Enabled = false;
            await _client.Add(item!);
            await GetAllItems();
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            _createButton.Enabled = true;
        }
    }

    protected virtual async Task UpdateItem()
    {
        if (_propertyGrid.SelectedObject is not TItem item)
        {
            MessageBox.Show($"Select a {typeof(TItem).Name} in the property grid to update.");
            return;
        }
        try
        {
            _updateButton.Enabled = false;
            var id = GetId(item);
            await _client.Update(id, item);
            await GetAllItems();
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            _updateButton.Enabled = true;
        }
    }

    protected virtual async Task DeleteItem()
    {
        if (_dataGridView.SelectedRows.Count == 0)
        {
            MessageBox.Show($"Select a {typeof(TItem).Name} to delete.");
            return;
        }
        var item = ((ItemDataTable<TItem>)_dataGridView.DataSource).GetItem(_dataGridView.SelectedRows[0].Index);
        var request = new DeleteRequest<TId> { Id = GetId(item) };
        using (var dlg = new RequestPropertyDialog(request, $"Delete {typeof(TItem).Name}"))
        {
            if (dlg.ShowDialog(this) != DialogResult.OK)
                return;
        }
        if (MessageBox.Show($"Delete this {typeof(TItem).Name}?", "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes)
            return;
        try
        {
            _deleteButton.Enabled = false;
            var id = request.Id;
            await _client.Delete(id);
            await GetAllItems();
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            _deleteButton.Enabled = true;
        }
    }

    // New search methods
    protected virtual async Task GetByField()
    {
        var request = new GetByFieldRequest();
        using (var dlg = new RequestPropertyDialog(request, "Search by Field"))
        {
            if (dlg.ShowDialog(this) != DialogResult.OK)
                return;
        }
        try
        {
            _getByFieldButton.Enabled = false;
            var items = await _client.GetByField(request.FieldName, request.Value);
            DisplayItems(items);
            MessageBox.Show($"Found {items.Count} items", "Search Results", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            _getByFieldButton.Enabled = true;
        }
    }

    protected virtual async Task GetByFields()
    {
        var request = new GetByFieldsRequest();
        using (var dlg = new RequestPropertyDialog(request, "Search by Fields"))
        {
            if (dlg.ShowDialog(this) != DialogResult.OK)
                return;
        }
        try
        {
            _getByFieldsButton.Enabled = false;
            var items = await _client.GetByFields(request.Criteria);
            DisplayItems(items);
            MessageBox.Show($"Found {items.Count} items", "Search Results", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            _getByFieldsButton.Enabled = true;
        }
    }

    protected virtual async Task GetByWhere()
    {
        var request = new WhereRequest();
        using (var dlg = new RequestPropertyDialog(request, "Search by Where Clause"))
        {
            if (dlg.ShowDialog(this) != DialogResult.OK)
                return;
        }
        try
        {
            _getByWhereButton.Enabled = false;
            var items = await _client.GetByWhere(request);
            DisplayItems(items);
            MessageBox.Show($"Found {items.Count} items", "Search Results", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            _getByWhereButton.Enabled = true;
        }
    }

    protected virtual async Task GetFirstByField()
    {
        var request = new GetByFieldRequest();
        using (var dlg = new RequestPropertyDialog(request, "Get First by Field"))
        {
            if (dlg.ShowDialog(this) != DialogResult.OK)
                return;
        }
        try
        {
            _getFirstByFieldButton.Enabled = false;
            var item = await _client.GetFirstByField(request.FieldName, request.Value);
            if (item != null)
            {
                DisplayItems(new List<TItem> { item });
                MessageBox.Show("Item found", "Search Results", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            else
            {
                MessageBox.Show("No item found", "Search Results", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            _getFirstByFieldButton.Enabled = true;
        }
    }

    protected virtual async Task ExistsByField()
    {
        var request = new GetByFieldRequest();
        using (var dlg = new RequestPropertyDialog(request, "Check Exists by Field"))
        {
            if (dlg.ShowDialog(this) != DialogResult.OK)
                return;
        }
        try
        {
            _existsByFieldButton.Enabled = false;
            var exists = await _client.ExistsByField(request.FieldName, request.Value);
            MessageBox.Show(exists ? "Item exists" : "Item does not exist", "Exists Check", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            _existsByFieldButton.Enabled = true;
        }
    }

    protected virtual void DisplayItems(IList<TItem> items)
    {
        int selectedIndex = _dataGridView.SelectedRows.Count > 0 ? _dataGridView.SelectedRows[0].Index : 0;
        _dataGridView.DataSource = new ItemDataTable<TItem>(items);
        if (_dataGridView.Rows.Count > 0)
        {
            if (selectedIndex < _dataGridView.Rows.Count)
                _dataGridView.Rows[selectedIndex].Selected = true;
            else
                _dataGridView.Rows[0].Selected = true;
        }
    }

    protected virtual TId GetId(TItem item) => item.Id;

    private void OpenSwaggerInBrowser()
    {
        var url = GetSwaggerUrl();
        try
        {
            System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo
            {
                FileName = url,
                UseShellExecute = true
            });
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Failed to open browser: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }

    protected virtual string GetSwaggerUrl()
    {
        string? baseUrl = null;
        if (_client is SevenSeals.Tss.Shared.IProtoClient protoClient)
        {
            baseUrl = (protoClient.Options as SevenSeals.Tss.Shared.ClientOptions)?.BaseUri;
        }
        return (baseUrl?.TrimEnd('/') ?? "") + "/swagger";
    }
}

// Helper classes for the search requests
public class GetByFieldRequest
{
    public string FieldName { get; set; } = string.Empty;
    public string Value { get; set; } = string.Empty;
}

public class GetByFieldsRequest
{
    public Dictionary<string, object> Criteria { get; set; } = new();
}
