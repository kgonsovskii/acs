using Actor.Client;
using Actor.Model;
using SevenSeals.Tss.Actor;
using System.ComponentModel;

namespace Gui.ControlPanel.WinForms.Forms;

public partial class PassClientForm : Form
{
    private readonly PassClient _client;
    private readonly PropertyGrid _propertyGrid;
    private readonly TableLayoutPanel _mainLayout;
    private readonly FlowLayoutPanel _buttonsPanel;
    private readonly Panel _contentPanel;

    private readonly Button btnGetAllPasses;
    private readonly Button btnGetPassById;
    private readonly Button btnCreatePass;
    private readonly Button btnUpdatePass;
    private readonly Button btnDeletePass;

    public PassClientForm(PassClient client)
    {
        _client = client;
        Dock = DockStyle.Fill;
        Text = "Pass Management";

        _mainLayout = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            ColumnCount = 3,
            RowCount = 1
        };
        _mainLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 200));
        _mainLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        _mainLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 300));

        _buttonsPanel = new FlowLayoutPanel
        {
            Dock = DockStyle.Fill,
            FlowDirection = FlowDirection.TopDown,
            AutoScroll = true,
            WrapContents = false
        };
        _contentPanel = new Panel
        {
            Dock = DockStyle.Fill,
            AutoScroll = true
        };
        _propertyGrid = new PropertyGrid
        {
            Dock = DockStyle.Fill,
            ToolbarVisible = true,
            CommandsVisibleIfAvailable = true
        };

        // Explicit buttons
        btnGetAllPasses = new Button { Text = "Get All Passes", Width = 180, Height = 30, Margin = new Padding(5) };
        btnGetPassById = new Button { Text = "Get Pass by ID", Width = 180, Height = 30, Margin = new Padding(5) };
        btnCreatePass = new Button { Text = "Create Pass", Width = 180, Height = 30, Margin = new Padding(5) };
        btnUpdatePass = new Button { Text = "Update Pass", Width = 180, Height = 30, Margin = new Padding(5) };
        btnDeletePass = new Button { Text = "Delete Pass", Width = 180, Height = 30, Margin = new Padding(5) };

        btnGetAllPasses.Click += btnGetAllPasses_Click;
        btnGetPassById.Click += btnGetPassById_Click;
        btnCreatePass.Click += btnCreatePass_Click;
        btnUpdatePass.Click += btnUpdatePass_Click;
        btnDeletePass.Click += btnDeletePass_Click;

        _buttonsPanel.Controls.Add(btnGetAllPasses);
        _buttonsPanel.Controls.Add(btnGetPassById);
        _buttonsPanel.Controls.Add(btnCreatePass);
        _buttonsPanel.Controls.Add(btnUpdatePass);
        _buttonsPanel.Controls.Add(btnDeletePass);

        _mainLayout.Controls.Add(_buttonsPanel, 0, 0);
        _mainLayout.Controls.Add(_contentPanel, 1, 0);
        _mainLayout.Controls.Add(_propertyGrid, 2, 0);
        Controls.Add(_mainLayout);
    }

    private async void btnGetAllPasses_Click(object? sender, EventArgs e)
    {
        try
        {
            btnGetAllPasses.Enabled = false;
            var passes = await _client.GetAll();
            DisplayPasses(passes);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnGetAllPasses.Enabled = true;
        }
    }

    private async void btnGetPassById_Click(object? sender, EventArgs e)
    {
        var request = new { Id = Guid.Empty };
        _propertyGrid.SelectedObject = request;
        if (MessageBox.Show("Get this pass?", "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes)
            return;
        try
        {
            btnGetPassById.Enabled = false;
            var pass = await _client.GetById(request.Id);
            if (pass != null)
                DisplayPasses(new[] { pass });
            else
                MessageBox.Show("Pass not found", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnGetPassById.Enabled = true;
        }
    }

    private async void btnCreatePass_Click(object? sender, EventArgs e)
    {
        var pass = new Pass();
        _propertyGrid.SelectedObject = pass;
        if (MessageBox.Show("Create this pass?", "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes)
            return;
        try
        {
            btnCreatePass.Enabled = false;
            await _client.Create(pass);
            MessageBox.Show("Pass created successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            btnGetAllPasses_Click(null, EventArgs.Empty);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnCreatePass.Enabled = true;
        }
    }

    private async void btnUpdatePass_Click(object? sender, EventArgs e)
    {
        var request = new { Id = Guid.Empty, Pass = new Pass() };
        _propertyGrid.SelectedObject = request;
        if (MessageBox.Show("Update this pass?", "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes)
            return;
        try
        {
            btnUpdatePass.Enabled = false;
            await _client.Update(request.Id, request.Pass);
            MessageBox.Show("Pass updated successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            btnGetAllPasses_Click(null, EventArgs.Empty);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnUpdatePass.Enabled = true;
        }
    }

    private async void btnDeletePass_Click(object? sender, EventArgs e)
    {
        var request = new { Id = Guid.Empty };
        _propertyGrid.SelectedObject = request;
        if (MessageBox.Show("Delete this pass?", "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes)
            return;
        try
        {
            btnDeletePass.Enabled = false;
            await _client.Delete(request.Id);
            MessageBox.Show("Pass deleted successfully", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            btnGetAllPasses_Click(null, EventArgs.Empty);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnDeletePass.Enabled = true;
        }
    }

    private void DisplayPasses(IEnumerable<Pass> passes)
    {
        var grid = new DataGridView
        {
            Dock = DockStyle.Fill,
            AutoGenerateColumns = true,
            AllowUserToAddRows = false,
            AllowUserToDeleteRows = false,
            ReadOnly = true,
            SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            MultiSelect = false
        };
        grid.DataSource = passes.ToList();
        _contentPanel.Controls.Clear();
        _contentPanel.Controls.Add(grid);
        grid.CellClick += (s, e) =>
        {
            if (e.RowIndex >= 0)
            {
                var pass = passes.ElementAt(e.RowIndex);
                _propertyGrid.SelectedObject = pass;
            }
        };
    }
} 
} 